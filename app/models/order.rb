class Order < ApplicationRecord
  # สร้าง order_number และคำนวณยอดรวมให้อัตโนมัติก่อนทำ Validation
  before_validation :generate_order_number, on: :create
  before_validation :calculate_total, on: :create
  before_validation :assign_user_info, if: :user_id?

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
      payment_pending: 1,
      confirmed: 2,
      preparing: 3,
      ready: 4,
      out_for_delivery: 5,
      completed: 6,
      cancelled: 7
  }, default: :pending

  enum :payment_status, {
      pending: 0,
      paid: 1,
      failed: 2,
      refunded: 3
  }, prefix: :true,
    default: :pending

  enum :payment_method, {
      stripe: 0,
      bank_transfer: 1,
      cash_on_pickup: 2
  } # validate: true

  validates :order_number, presence: true, uniqueness: true
  validates :subtotal_cents, :delivery_fee_cents, :total_cents, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # เพิ่ม Validation สำหรับเก็บข้อมูลติดต่อของ Guest
  validates :customer_name, presence: true
  validates :phone_number, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  # ที่อยู่จัดส่ง: บังคับกรอกเฉพาะเมื่อ order_type เป็น delivery และไม่ใช่การจ่ายเงินสดหน้าร้าน
  validates :delivery_address, presence: true, if: :delivery?
  validates :payment_method, presence: true # inclusion: { in: %w[stripe bank_transfer] } เขียนซ้ำกับการกำหนด enum ข้างบน ให้เลือกอย่างใดอย่างนึง
  validates :total_cents, numericality: { greater_than_or_equal_to: 0 }


  # 3. Helper Methods (คำนวณราคาย่อยสำหรับแสดงผล)
  def total_price
    total_cents / 100.0
  end
  # Custom Validations
  validate :delivery_requires_zone
  validate :delivery_zone_must_be_active
  validate :delivery_requires_address_snapshot
  validate :takeaway_has_no_delivery_fee
  validate :total_matches_amounts

  private

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

  # 1. สุ่ม/สร้างเลขออเดอร์ที่ไม่ซ้ำกัน (เช่น TF-20260913-8492)
  def generate_order_number
    return if order_number.present?
    # Format วันที่: DDMMYYYY
    # Format วันที่: DDMMYYYY (เช่น 13092026)
    date_prefix = Time.current.strftime("%d%m%Y")

    # นับจำนวนออเดอร์ที่มีขึ้นในวันนี้
    today_orders_count = Order.where("created_at >= ?", Time.current.beginning_of_day).count

    # รันเลขต่อ เช่น 001, 002, 003
    sequence = (today_orders_count + 1).to_s.rjust(3, "0")

    # กำหนดค่าให้ order_number (เช่น 13092026-001)
    self.order_number = "#{date_prefix}-#{sequence}"
    # self.order_number = "#{Time.current.strftime('%Y%m%d')}-#{sequence}"
  end

  # 2. คำนวณยอด total_cents ให้ตรงกับ subtotal_cents + delivery_fee_cents เสมอ
  def calculate_total
    self.subtotal_cents ||= 0
    self.delivery_fee_cents ||= 0
    self.total_cents = subtotal_cents + delivery_fee_cents
  end

  def assign_user_info
    return unless user

    self.customer_name ||= user.try(:name) || user.try(:full_name)
    self.email ||= user.email
    self.phone_number ||= user.try(:phone) || user.try(:phone_number)
  end
end
