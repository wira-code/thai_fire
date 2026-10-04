class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  has_many :cart_item_options, dependent: :destroy
  has_many :cart_item_add_ons, dependent: :destroy

  accepts_nested_attributes_for :cart_item_options, :cart_item_add_ons, allow_destroy: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  validate :total_cents
  validate :unit_price_cents

  def unit_price_cents
    base_price = product.price_cents || 0
    options_price = cart_item_options.sum(:price_cents)
    add_ons_price = cart_item_add_ons.sum { |a| a.respond_to?(:price_cents) ? (a.price_cents || 0) : 0 }
    # add_ons_price = cart_item_add_ons.sum(:price_cents)

    base_price + options_price + add_ons_price
  end

  def total_cents
    (unit_price_cents * quantity) / 100.0
  end
end
