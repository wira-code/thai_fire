class CartItemAddOn < ApplicationRecord
  belongs_to :cart_item
  belongs_to :add_on

  validates :add_on_name, presence: true
  validates :price_cents, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  validate :total_cents

  def total_cents
    price_cents * quantity
  end
end
