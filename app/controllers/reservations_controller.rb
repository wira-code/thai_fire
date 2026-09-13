class ReservationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :new, :create ], raise: false
  def new
    @reservation = Reservation.new
  end

  def create
    @reservation = Reservation.new(reservation_params)
    @reservation.status ||= "pending"

    if user_signed_in?
      @reservation.name ||= current_user.name
      @reservation.email ||= current_user.email
    end

    if @reservation.save
      redirect_to reservation_path(@reservation), notice: "จองโต๊ะสำเร็จ! ทางร้านจะยืนยันการจองผ่านอีเมล/โทรศัพท์"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

  private

  def reservation_params
    params.require(:reservation).permit(:name, :email, :phone, :reservation_date, :reservation_time, :guests)
  end
end
