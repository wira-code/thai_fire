class CreateProductOptions < ActiveRecord::Migration[8.1]
  def change
    create_table :product_options do |t|
      t.references :product, null: false, foreign_key: true
      t.references :option, null: false, foreign_key: true
      t.integer :position, null: false, default: 0

      t.timestamps
    end
  add_index :product_options, [ :product_id, :option_id ], unique: true
  add_index :product_options, [ :product_id, :position ]
  end
end
