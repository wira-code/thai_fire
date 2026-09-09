class OrdersController < ApplicationController
  # before_action :authenticate_user!
  # บังคับให้เข้าสู่ระบบก่อนสั่งซื้อ
  # before_action :set_order, only: [ :show ]

  # ✅ สั่งให้ข้ามการตรวจ Login เฉพาะ new และ create
  skip_before_action :authenticate_user!, only: [ :new, :create ], raise: false

  def index
    # ประวัติการสั่งซื้อของผู้ใช้
    @orders = current_user.orders.order(created_at: :desc)
  end

  def show
    if user_signed_in?
    @order = current_user.orders.find(params[:id])
    else
      # เช็กว่า order id ตรงกับที่บันทึกไว้ใน session ตอนสั่งซื้อหรือไม่
      if session[:last_order_id] == params[:id].to_i
        @order = Order.find(params[:id])
      else
        redirect_to root_path, alert: "คุณไม่มีสิทธิ์เข้าถึงออเดอร์นี้"
      end
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "ไม่พบข้อมูลคำสั่งซื้อ"
  end

  def new
    # ใช้ current_cart helper (ถ้าทำไว้) หรือดึงจาก current_user สลับกับ session
    @cart = current_user&.cart || current_cart
    @cart_items = @cart&.cart_items || []
    # @cart = current_user.cart
    # @cart_items = @cart.cart_items

    # ถ้าตะกร้าว่างเปล่า ไม่ให้เข้าหน้า checkout
    if @cart_items.empty?
      redirect_to root_path, alert: "ตะกร้าสินค้าของคุณว่างเปล่า"
      return
    end

    @order = Order.new
  end

  def create
    @cart = current_user&.cart || current_cart
    @cart_items = @cart&.cart_items || []

    # ถ้าตะกร้าว่างเปล่า ไม่ให้เข้าหน้า checkout
    if @cart_items.empty?
      redirect_to root_path, alert: "ตะกร้าสินค้าของคุณว่างเปล่า"
      return
    end

    # คำนวณราคารวมทั้งหมด
    total_cents = @cart_items.sum do |item|
      options_price = item.cart_item_options.sum(:price_cents)
      add_ons_price = item.cart_item_add_ons.sum { |a| a.price_cents * a.quantity }
      (item.product.price_cents + options_price + add_ons_price) * item.quantity
    end

    # ✅ แยกการสร้าง Order ระหว่าง User กับ Guest
    if user_signed_in?
    @order = current_user.orders.build(order_params)
    @order.email = current_user.email if @order.email.blank?
    else
      @order = Order.new(order_params)
    end

    @order.total_cents = total_cents
    @order.status = "pending"# หรือสถานะเริ่มต้นที่คุณกำหนดไว้ใน Model

    if @order.save
      # ย้ายรายการจาก CartItem ไปยัง OrderItem
      @cart_items.each do |cart_item|
        unit_price = cart_item.product.price_cents +
                     cart_item.cart_item_options.sum(:price_cents) +
                     cart_item.cart_item_add_ons.sum { |a| a.price_cents * a.quantity }

        @order.order_items.create!(
          product: cart_item.product,
          quantity: cart_item.quantity,
          price_cents: unit_price,
          special_request: cart_item.special_request
        )

        # (ถ้ามี) ก๊อบปี้ options และ add_ons ไปยัง order_item ด้วยตามโครงสร้าง database ของคุณ
      end

      # เคลียร์รายการในตะกร้าสินค้า
      @cart_items.destroy_all

      if @order.payment_method == "stripe"
      # TODO: ใส่โค้ด Stripe เมื่อพร้อมใช้งาน
      session[:last_order_id] = @order.id unless user_signed_in?
      redirect_to order_path(@order), notice: "สั่งซื้อสำเร็จ! (ชำระผ่าน Stripe)"
      elsif @order.bank_transfer?
        # 2. กรณีเลือก โอนเงิน/QR Code
        session[:last_order_id] = @order.id unless user_signed_in?
        redirect_to order_path(@order), notice: "สั่งซื้อสำเร็จ! กรุณาโอนเงินและแนบสลิปชำระเงิน"
      elsif @order.cash_on_pickup?
        # 3. กรณีจ่ายเงินสดหน้าร้าน: ไปหน้า show พร้อมข้อความยืนยัน
        session[:last_order_id] = @order.id unless user_signed_in?
        redirect_to order_path(@order), notice: "สั่งซื้อสำเร็จ! กรุณาชำระเงินสดเมื่อมารับสินค้าที่ร้าน"
      else
        render :new, status: :unprocessable_entity
      end
      OrderMailer.confirmation_email(@order).deliver_later
    end
  end

  def upload_slip
    @order = Order.find(params[:id])
    if @order.update(slip_params)
      @order.update(status: "payment_pending") # เปลี่ยนสถานะเป็นรอร้านตรวจสอบ
      redirect_to order_path(@order), notice: "อัปโหลดสลิปเรียบร้อยแล้ว ร้านค้ากำลังตรวจสอบ"
    else
      redirect_to order_path(@order), alert: "ไม่สามารถอัปโหลดสลิปได้"
    end
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to orders_path, alert: "ไม่พบข้อมูลคำสั่งซื้อ"
  end

  def order_params
    params.require(:order).permit(
      :customer_name,
      :email,
      :phone_number,
      :delivery_address,
      :phone_number,
      :customer_note,
      :payment_method)
  end

  def slip_params
  params.require(:order).permit(:payment_slip)
  end
end
