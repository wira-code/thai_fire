class Reservation < ApplicationRecord
  belongs_to :user, optional: true # 👈 อนุญาตให้ Guest จองได้โดยไม่ต้อง Login

  validates :name, :email, :phone, :reservation_date, :reservation_time, :guests, presence: true
end
