class CreateAddOns < ActiveRecord::Migration[8.1]
  def change
    create_table :add_ons do |t|
      t.string :name, null: false
      t.text :description
      t.integer :price_cents, null: false, default: 0
      t.boolean :available, null: false, default: true
      t.integer :position, null: false, default: 0

      t.timestamps
    end
  add_index :add_ons, :name, unique: true
  add_index :add_ons, :available
  add_index :add_ons, :position
  end
end
