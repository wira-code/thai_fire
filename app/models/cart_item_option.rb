class CartItemOption < ApplicationRecord
  belongs_to :cart_item

  validates :option_name, presence: true
  validates :choice_name, presence: true
  validates :price_cents, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
