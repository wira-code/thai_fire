class Cart < ApplicationRecord
  belongs_to :user, optional: true

  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  validate :total_cents

  def total_cents
    cart_items.sum(&:total_cents)
  end
end
