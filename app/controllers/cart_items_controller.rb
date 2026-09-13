class CartItemsController < ApplicationController
  before_action :set_cart_item, only: [ :increase, :decrease, :destroy ]

  def create
    @cart = current_cart # เมธอดดึง cart ของผู้ใช้ปัจจุบัน (หรือดึงจาก session[:cart_id])
    @product = Product.find(params[:product_id])

    # 1. สร้าง CartItem หลัก
    @cart_item = @cart.cart_items.create!(
      product: @product,
      quantity: params[:quantity] || 1,
      special_request: params[:special_request]
    )

    # 2. บันทึก Options (เนื้อสัตว์, ความเผ็ด)
    selected_choice_ids = []
    selected_choice_ids += params[:options].values if params[:options].present?
    selected_choice_ids += params[:option_choice_ids] if params[:option_choice_ids].present?

    OptionChoice.where(id: selected_choice_ids).each do |choice|
      @cart_item.cart_item_options.create!(
        option_name: choice.option.name,
        choice_name: choice.name,
        price_cents: choice.price_cents
      )
    end

    # 3. บันทึก Add-ons ตามจำนวนที่ระบุ (วนลูปดึงเฉพาะตัวที่มี quantity > 0)
    if params[:add_ons].present?
      params[:add_ons].each do |add_on_id, qty|
        quantity = qty.to_i
        next if quantity <= 0 # ข้ามตัวที่ไม่ได้เลือกจำนวน

        add_on = AddOn.find_by(id: add_on_id)
        next unless add_on&.available?

        @cart_item.cart_item_add_ons.create!(
          add_on_id: add_on.id,
          add_on_name: add_on.name,
          price_cents: add_on.price_cents,
          quantity: quantity
        )
      end
    end

    redirect_to product_path(params[:product_id]), notice: "เพิ่มรายการลงในตะกร้าเรียบร้อยแล้ว"
  end

  def update
    @cart_item = current_cart.cart_items.find(params[:id])
    if @cart_item.update(quantity: params[:quantity])
      redirect_to cart_path, notice: "อัปเดตจำนวนเรียบร้อยแล้ว"
    else
      redirect_to cart_path, alert: "ไม่สามารถอัปเดตจำนวนได้"
    end
  end

  def destroy
    @cart_item = current_cart.cart_items.find(params[:id])
    @cart_item.destroy
    redirect_to cart_path, notice: "ลบรายการออกจากตะกร้าเรียบร้อยแล้ว"
  end

  # POST /cart_items/:id/increase
  def increase
    @cart_item.increment!(:quantity)
    redirect_back fallback_location: root_path
  end

  # POST /cart_items/:id/decrease
  def decrease
    if @cart_item.quantity > 1
      @cart_item.decrement!(:quantity)
    else
      @cart_item.destroy # ถ้าเหลือ 1 แล้วกดลด ให้ลบออกจากตะกร้า
    end
    redirect_back fallback_location: root_path
  end

  private

  def set_cart_item
    @cart_item = CartItem.find(params[:id])
  end
end
