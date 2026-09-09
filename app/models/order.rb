class Order < ApplicationRecord
  # ใส่ optional: true เพื่อให้ user_id เป็น nil ได้สำหรับ Guest
  belongs_to :user, optional: true
  belongs_to :address, optional: true
  belongs_to :delivery_zone, optional: true

  has_many :order_items, dependent: :destroy
  # has_one :payment, dependent: :destroy
  has_one_attached :payment_slip

  enum :order_type, {
      takeaway: 0,
      delivery: 1
    }, validate: true

  enum :status, {
      pending: 0,
      confirmed: 1,
      preparing: 2,
      ready: 3,
      out_for_delivery: 4,
      completed: 5,
      cancelled: 6
    }, validate: true

  enum :payment_status, {
      pending: 0,
      paid: 1,
      failed: 2,
      refunded: 3
    }, prefix: :payment,
    validate: true

  enum :payment_method, {
      stripe: 0,
      bank_transfer: 1,
      cash_on_pickup: 2
    }, validate: true

  validates :order_number, presence: true, uniqueness: true
  validates :subtotal_cents, :delivery_fee_cents, :total_cents, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # เพิ่ม Validation สำหรับเก็บข้อมูลติดต่อของ Guest
  validates :customer_name, presence: true
  validates :phone_number, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :delivery_address, presence: true
  validates :payment_method, presence: true, inclusion: { in: %w[stripe bank_transfer] }
  validates :total_price_cents, numericality: { greater_than_or_equal_to: 0 }

  # 3. Status Definition (กำหนดสถานะของ Order)
  # ช่วยให้เรียกเช็กออเดอร์ง่ายขึ้น เช่น order.paid?, order.pending?
  STATUSES = %w[pending payment_pending paid preparing delivering completed cancelled].freeze
  validates :status, inclusion: { in: STATUSES }

  # 4. Helper Methods (คำนวณราคาย่อยสำหรับแสดงผล)
  def total_price
    total_price_cents / 100.0
  end

  validate :delivery_requires_address
  validate :delivery_requires_zone
  validate :delivery_zone_must_be_active
  validate :delivery_requires_address_snapshot
  validate :takeaway_has_no_delivery_fee
  validate :total_matches_amounts

  private
  def delivery_requires_address
    if delivery? && address.nil?
      errors.add(:address, "must be present for delivery orders")
    end
  end

  def delivery_requires_zone
    if delivery? && delivery_zone.nil?
      errors.add(:delivery_zone, "must be present for delivery orders")
    end
  end

  def delivery_zone_must_be_active
    if delivery? && delivery_zone.present? && !delivery_zone.active?
      errors.add(:delivery_zone, "must be active for delivery orders")
    end
  end

  def delivery_requires_address_snapshot
    if delivery? && delivery_address.blank?
      errors.add(:delivery_address, "must be present for delivery orders")
    end
  end

  def takeaway_has_no_delivery_fee
    if takeaway? && delivery_fee_cents.to_i > 0
      errors.add(:delivery_fee_cents, "must be zero for takeaway orders")
    end
  end

  def total_matches_amounts
    expected_total = subtotal_cents.to_i + delivery_fee_cents.to_i
    if total_cents.to_i != expected_total
      errors.add(:total_cents, "does not match subtotal and delivery fee")
    end
  end
end
