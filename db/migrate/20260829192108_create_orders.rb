class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :address, null: true, foreign_key: true
      t.references :delivery_zone, null: true, foreign_key: true
      t.string :order_number, null: false
      t.integer :order_type, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.integer :payment_status, null: false, default: 0
      t.integer :subtotal_cents, null: false, default: 0
      t.integer :delivery_fee_cents, null: false, default: 0
      t.integer :total_cents, null: false, default: 0
      t.datetime :scheduled_at
      t.text :customer_note
      t.text :delivery_address

      t.timestamps
    end
  add_index :orders, :order_number, unique: true
  add_index :orders, :status
  add_index :orders, :payment_status
  add_index :orders, :order_type
  add_index :orders, [ :user_id, :created_at ]
  end
end
