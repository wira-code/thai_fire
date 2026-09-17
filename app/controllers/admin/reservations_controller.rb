class Admin::ReservationsController < ApplicationController
  before_action :set_reservation, only: [ :show, :update, :destroy ]
  def index
      # ดึงรายการจอง เรียงจากวัน-เวลาจองล่าสุดขึ้นก่อน พร้อมโหลด user (ถ้ามี)
      @reservations = Reservation.includes(:user).order(reservation_date: :desc, reservation_time: :desc)
  end

  def show
  end

  def update
    if @reservation.update(reservation_params)
      redirect_to admin_reservations_path, notice: "อัปเดตสถานะการจองเรียบร้อยแล้ว"
    else
      redirect_to admin_reservations_path, alert: "ไม่สามารถอัปเดตสถานะการจองได้"
    end
  end

  def destroy
    @reservation.destroy
      redirect_to admin_reservations_path, notice: "ลบรายการจองเรียบร้อยแล้ว"
  end

  private

    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    def reservation_params
      params.require(:reservation).permit(:status, :guests_count, :special_request)
    end
end
