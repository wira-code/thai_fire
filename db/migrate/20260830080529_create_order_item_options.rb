class CreateOrderItemOptions < ActiveRecord::Migration[8.1]
  def change
    create_table :order_item_options do |t|
      t.references :order_item, null: false, foreign_key: true
      t.string :option_name, null: false
      t.string :choice_name, null: false
      t.integer :price_cents, null: false, default: 0

      t.timestamps
    end
  end
end
