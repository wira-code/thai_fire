class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.references :category, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.integer :price_cents, null: false, default: 0
      t.string :image_url
      t.boolean :active, null: false, default: true
      t.boolean :available, null: false, default: true
      t.integer :position, null: false, default: 0

      t.timestamps
    end
  add_index :products, :name, unique: true
  add_index :products, :active
  add_index :products, :available
  add_index :products, [ :category_id, :position ]
  end
end
