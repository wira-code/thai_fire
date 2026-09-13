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

    # ถ้าล็อกอินอยู่ ให้เติมข้อมูลติดต่อตั้งแต่อยู่ในหน้า new
    if user_signed_in?
      @order.customer_name = current_user.name # หรือ current_user.full_name ตามโครงสร้าง User model
      @order.email = current_user.email
      @order.phone_number = current_user.phone if current_user.respond_to?(:phone) # หรือ current_user.phone_number
    end
  end

  def create
    @cart = current_user&.cart || current_cart
    @cart_items = @cart&.cart_items || []

    # ถ้าตะกร้าว่างเปล่า ไม่ให้เข้าหน้า checkout
    if @cart_items.empty?
      redirect_to root_path, alert: "ตะกร้าสินค้าของคุณว่างเปล่า"
      return
    end

    # ✅ แยกการสร้าง Order ระหว่าง User กับ Guest
    # 1. ✅ สร้าง @order จาก params ก่อนเสมอ
    @order = Order.new(order_params)

    # 2. ✅ ถ้าล็อกอิน ให้ผูก user_id และเติมข้อมูลจาก current_user ทับกรณีไม่ได้กรอก
    if user_signed_in?
      @order.user = current_user
      @order.customer_name ||= current_user.name if @order.customer_name.blank?
      @order.email ||= current_user.email if @order.email.blank?
      @order.phone_number ||= current_user.phone if @order.respond_to?(:phone) && @order.phone_number.blank?
    end

    # คำนวณราคารวมทั้งหมด
    subtotal_cents = @cart_items.sum do |item|
    options_price = item.cart_item_options.sum(:price_cents)
    add_ons_price = item.cart_item_add_ons.sum { |a| a.price_cents * a.quantity }
      (item.product.price_cents + options_price + add_ons_price) * item.quantity
    end

    # 2. กำหนดค่าให้ครบทั้ง 3 คอลัมน์สำคัญ
    @order.subtotal_cents = subtotal_cents
    @order.delivery_fee_cents = 0
    @order.total_cents = subtotal_cents + @order.delivery_fee_cents
    @order.status = "pending"# หรือสถานะเริ่มต้นที่คุณกำหนดไว้ใน Model

    # 🟢 เพิ่มบรรทัดนี้หากต้องการให้ Controller ช่วยการันตีอีกชั้น
    if @order.order_number.blank?
      date_prefix = Time.current.strftime("%d%m%Y")
      today_orders_count = Order.where("created_at >= ?", Time.current.beginning_of_day).count
      @order.order_number = "#{date_prefix}-#{(today_orders_count + 1).to_s.rjust(3, '0')}"
    end

    # ถ้าเป็น Take away ให้เคลียร์ที่อยู่จัดส่งเป็น nil เสมอ
    if @order.takeaway?|| @order.order_type == "takeaway"
      @order.delivery_address = nil
    end

    if @order.save
      @cart_items.each do |cart_item|
      # ย้ายรายการจาก CartItem ไปยัง OrderItem
      # 1. คำนวณราคาต่อชิ้น
      unit_price_cents = cart_item.product.price_cents +
                        cart_item.cart_item_options.sum(:price_cents) +
                        cart_item.cart_item_add_ons.sum { |a| a.price_cents * a.quantity }

      # 2. คำนวณราคารวมของ item นั้นๆ (ราคาต่อชิ้น * จำนวน)
      item_total_cents = unit_price_cents * cart_item.quantity

        # 3. บันทึกลง database ด้วยชื่อคอลัมน์ที่ถูกต้อง
        @order.order_items.create!(
          product: cart_item.product,
          product_name: cart_item.product.name,
          quantity: cart_item.quantity,
          unit_price_cents: unit_price_cents,
          total_cents: item_total_cents,
          special_request: cart_item.special_request
        )

      # (ถ้ามี) ก๊อบปี้ options และ add_ons ไปยัง order_item ด้วยตามโครงสร้าง database ของคุณ
    end

      # เคลียร์รายการในตะกร้าสินค้า
      @cart_items.destroy_all

      # บันทึก session ให้ Guest เข้าดูออเดอร์ได้
      session[:last_order_id] = @order.id unless user_signed_in?

      # ส่งอีเมลยืนยัน (ถ้ามี)
      OrderMailer.confirmation_email(@order).deliver_later rescue nil

      # Redirect ตามประเภท Payment Method
      if @order.payment_method == "stripe"
        # TODO: ใส่โค้ด Stripe เมื่อพร้อมใช้งาน
        # 1. สร้างรายการสินค้าส่งไปให้ Stripe
        line_items = @order.order_items.map do |item|
          {
            price_data: {
              currency: "eur", # หรือ THB ตามสกุลเงินที่ใช้
              unit_amount: item.unit_price_cents,
              product_data: {
                name: item.product_name
              }
            },
            quantity: item.quantity
          }
        end
          # 2. สร้าง Stripe Checkout Session
          session = Stripe::Checkout::Session.create(
          payment_method_types: [ "card" ],
          line_items: line_items,
          mode: "payment",
          success_url: order_url(@order, success: true),
          cancel_url: order_url(@order, cancel: true),
          client_reference_id: @order.id
        )
          # 3. บันทึก checkout_session_id ไว้ใน Order (ถ้ามีคอลัมน์เก็บ) แล้ว Redirect ไปหน้าชำระเงิน Stripe
          @order.update(checkout_session_id: session.id) if @order.respond_to?(:checkout_session_id)
          redirect_to session.url, allow_other_host: true
        # session[:last_order_id] = @order.id unless user_signed_in?
        # redirect_to order_path(@order), notice: "สั่งซื้อสำเร็จ! (ชำระผ่าน Stripe)"
      elsif @order.bank_transfer?
        # 2. กรณีเลือก โอนเงิน/QR Code
        # session[:last_order_id] = @order.id unless user_signed_in?
        redirect_to order_path(@order), notice: "สั่งซื้อสำเร็จ! กรุณาโอนเงินและแนบสลิปชำระเงิน"
      elsif @order.cash_on_pickup?
        # @order.delivery_address = nil
        # 3. กรณีจ่ายเงินสดหน้าร้าน: ไปหน้า show พร้อมข้อความยืนยัน
        # กำหนด status เป็น pending (หรือ confirmed) สำหรับรอจ่ายเงินสดหน้าร้าน
        @order.update(status: "pending")
        # session[:last_order_id] = @order.id unless user_signed_in?
        redirect_to order_path(@order), notice: "สั่งซื้อสำเร็จ! กรุณาชำระเงินสดเมื่อมารับสินค้าที่ร้าน"
      else
        redirect_to order_path(@order)
      end
    else
      # กรณี save ไม่ผ่าน จะทำงานตรงนี้จุดเดียวเท่านั้น
      render :new, status: :unprocessable_entity
    end
  end

  def upload_slip
    @order = Order.find(params[:id])

    if @order.update(slip_params)
      # เปลี่ยนสถานะ Order เป็น payment_pending เพื่อรอร้านตรวจสอบ
      @order.update(status: "payment_pending") if @order.respond_to?(:status)

      redirect_to order_path(@order), notice: "อัปโหลดสลิปเรียบร้อยแล้ว ร้านค้ากำลังตรวจสอบรายการชำระเงินของคุณ"
    else
      redirect_to order_path(@order), alert: "ไม่สามารถอัปโหลดสลิปได้ กรุณาลองใหม่อีกครั้ง"
    end
  end

  private

  # def set_order
  # @order = current_user.orders.find(params[:id])
  # rescue ActiveRecord::RecordNotFound
  # redirect_to orders_path, alert: "ไม่พบข้อมูลคำสั่งซื้อ"
  # end

  def order_params
    params.require(:order).permit(
      :order_type,
      :customer_name,
      :email,
      :phone_number,
      :delivery_address,
      :delivery_time,
      :customer_note,
      :payment_method,
      :special_request
      )
  end

  def slip_params
  params.require(:order).permit(:payment_slip)
  end
end
