class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  has_many :order_item_options, dependent: :destroy
  has_many :order_item_add_ons, dependent: :destroy

  validates :product_name, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price_cents, :total_cents, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :total_matches_quantity_and_price
  validates :special_request, length: { maximum: 500 }, allow_blank: true

  private

  def total_matches_quantity_and_price
    return if quantity.blank? ||
              unit_price_cents.blank? ||
              total_cents.blank?
    expected_total = quantity * unit_price_cents

    unless total_cents == expected_total
      errors.add(:total_cents, "must equal quantity * unit price")

      # return if total_cents == expected_total
      # errors.add(:total_cents, "must equal quantity * unit price")
    end
  end
end
