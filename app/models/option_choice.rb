class OptionChoice < ApplicationRecord
  belongs_to :option

  validates :name, presence: true, uniqueness: { scope: :option_id }
  validates :price_cents, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
