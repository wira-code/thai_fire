class Product < ApplicationRecord
  belongs_to :category

  has_many :product_options, dependent: :destroy
  has_many :options, through: :product_options
  has_many :product_add_ons, dependent: :destroy
  has_many :add_ons, through: :product_add_ons
  has_many :order_items, dependent: :restrict_with_error
  has_one :image, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :price_cents, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :active, inclusion: { in: [ true, false ] }
end
