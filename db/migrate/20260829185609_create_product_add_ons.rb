class CreateProductAddOns < ActiveRecord::Migration[8.1]
  def change
    create_table :product_add_ons do |t|
      t.references :product, null: false, foreign_key: true
      t.references :add_on, null: false, foreign_key: true
      t.integer :position, null: false, default: 0

      t.timestamps
    end
  add_index :product_add_ons, [ :product_id, :add_on_id ], unique: true
  add_index :product_add_ons, [ :product_id, :position ]
  end
end
