class AddPaymentMethodToPayment < ActiveRecord::Migration[8.1]
  def change
    add_column :payments, :payment_method, :integer, null: false
  end
end
