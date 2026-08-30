class CreateOrderItemAddOns < ActiveRecord::Migration[8.1]
  def change
    create_table :order_item_add_ons do |t|
      t.references :order_item, null: false, foreign_key: true
      t.references :add_on, null: false, foreign_key: true
      t.string :add_on_name, null: false
      t.integer :price_cents, null: false, default: 0
      t.integer :quantity, null: false, default: 0

      t.timestamps
    end
  end
end
