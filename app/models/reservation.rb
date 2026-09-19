class Reservation < ApplicationRecord
  belongs_to :user, optional: true # 👈 อนุญาตให้ Guest จองได้โดยไม่ต้อง Login
  # enum :status, {
  # pending: 0,
  #  confirmed: 1,
  #  completed: 2,
  #  cancelled: 3
  # }, default: :pending

  validates :name, :email, :phone, :reservation_date, :reservation_time, :guests, presence: true
  # validates :status, presence: true, inclusion: { in: statuses.keys }

  # ป้องกันการจองซ้ำซ้อนหรือย้อนหลัง (Custom Validation)
  validate :reservation_date_cannot_be_in_the_past

  private

  def reservation_date_cannot_be_in_the_past
    if reservation_date.present? && reservation_date < Time.current
      errors.add(:reservation_date, "ไม่สามารถเลือกวันที่หรือเวลาในอดีตได้")
    end
  end
end
