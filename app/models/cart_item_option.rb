class CartItemOption < ApplicationRecord
  belongs_to :cart_item
  belongs_to :option_choice, optional: true

  validates :option_name, presence: true
  validates :choice_name, presence: true
  validates :price_cents, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }


  def total_cents
    price_cents * cart_item.quantity
  end
end
