class Payment < ApplicationRecord
  belongs_to :order

  enum :payment_method, {
    cash: 0,
    card: 1,
    online: 2
  }, validate: true

  enum :status, {
    pending: 0,
    paid: 1,
    failed: 2,
    refunded: 3
  }, validate: true

  PROVIDERS = %w[
    stripe
    paypal
    sumup
    cash
  ].freeze

  validates :payment_method, presence: true
  validates :provider, presence: true, inclusion: { in: PROVIDERS }
  validates :amount_cents, presence: true, numericality: { only_integer: true, greater_than: 0 }

  validate :valid_provider_for_payment_method
  validate :amount_matches_order_total

  private

  def valid_provider_for_payment_method
    case payment_method
    when "cash"
      errors.add(:provider, "must be cash") unless provider == "cash"
    when "card"
      unless %w[stripe sumup].include?(provider)
      errors.add(:provider, "must be stripe or sumup")
      end
    when "online"
      unless %w[stripe paypal].include?(provider)
      errors.add(:provider, "must be stripe or paypal")
      end
    end
  end

  def amount_matches_order_total
    return if order.blank? || amount_cents.blank?

    if amount_cents != order.total_cents
      errors.add(:amount_cents, "must match order total")
    end
  end
end
