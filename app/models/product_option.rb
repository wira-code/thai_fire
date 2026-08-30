class ProductOption < ApplicationRecord
  belongs_to :product
  belongs_to :option

  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :option_id, uniqueness: { scope: :product_id }
end
