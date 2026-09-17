module Admin
  class Admin::OrdersController < ApplicationController
    before_action :set_order, only: [ :show, :update ]
    def index
      # ดึงออเดอร์ทั้งหมด เรียงจากใหม่อยู่บนสุด
      @orders = Order.includes(:user).order(created_at: :desc)
    end

    def show
      # ดึงรายการสินค้าในออเดอร์นี้ (OrderItems)
      @order_items = @order.respond_to?(:order_items) ? @order.order_items.includes(:product) : []
    end

    def update
      if @order.update(order_params)
        redirect_to admin_orders_path, notice: "อัปเดตสถานะออเดอร์ ##{@order.id} เรียบร้อยแล้ว"
      else
        redirect_to admin_orders_path, alert: "ไม่สามารถอัปเดตสถานะออเดอร์ได้"
      end
    end

    private

    def set_order
      # ค้นหาด้วย id หรือ order_number (ถ้าหาด้วย id ไม่เจอ)
      @order = Order.find_by(id: params[:id]) || Order.find_by(order_number: params[:id])
    end

    def order_params
      params.require(:order).permit(:status)
    end
  end
end
