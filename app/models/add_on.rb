class AddOn < ApplicationRecord
  has_many :product_add_ons, dependent: :destroy
  has_many :products, through: :product_add_ons
  has_many :order_item_add_ons, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
  validates :price_cents, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :position, numericality: { only_integer: true }
end
