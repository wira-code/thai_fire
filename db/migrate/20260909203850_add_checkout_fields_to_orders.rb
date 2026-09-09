class AddCheckoutFieldsToOrders < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :delivery_time, :datetime
    add_column :orders, :payment_method, :integer, default: 0
  end
end
