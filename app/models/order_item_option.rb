class OrderItemOption < ApplicationRecord
  belongs_to :order_item

  validates :option_name, presence: true
  validates :choice_name, presence: true
  validates :price_cents, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
