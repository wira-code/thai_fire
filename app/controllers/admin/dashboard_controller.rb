class Admin::DashboardController < ApplicationController
  # หากมีระบบ Authentication/Authorization สำหรับ Admin ให้เช็กที่นี่
  # before_action :authenticate_admin!
  def index
    today_range = Time.current.beginning_of_day..Time.current.end_of_day

      # 1. ยอดขายประจำวัน (คำนวณจาก Order ของวันนี้)
      # หมายเหตุ: หากมี status ของ order เช่น completed ให้ดึงเฉพาะออเดอร์ที่สำเร็จ
      @today_sales = Order.where(created_at: today_range).sum(:total_cents)

      # 2. จำนวนออเดอร์ใหม่ของวันนี้
      @today_orders_count = Order.where(created_at: today_range).count

      # 3. จำนวนการจองโต๊ะของวันนี้
      @today_reservations_count = Reservation.where(reservation_date: today_range).count

      # 4. รายการจองโต๊ะของวันนี้ (ดึงมาแสดงในลิสต์ย่อ)
      @today_reservations = Reservation.where(reservation_date: today_range).order(reservation_date: :asc).limit(5)
  end
end
