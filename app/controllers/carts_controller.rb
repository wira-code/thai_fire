class CartsController < ApplicationController
  def show
    @cart = current_cart
    @cart_items = @cart.cart_items.includes(:product, :cart_item_options, :cart_item_add_ons)
  end
end
