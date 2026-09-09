class AddGuestFieldsToOrders < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :customer_name, :string
    add_column :orders, :email, :string
    add_column :orders, :phone_number, :string
  end
end
