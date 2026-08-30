class CreateAddresses < ActiveRecord::Migration[8.1]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :label, null: false
      t.string :full_name, null: false
      t.string :phone, null: false
      t.string :address_line1, null: false
      t.string :address_line2, null: false
      t.string :city, null: false
      t.string :postal_code, null: false
      t.string :country, null: false, default: "France"
      t.decimal :latitude, precision: 10, scale: 7
      t.decimal :longitude, precision: 10, scale: 7
      t.boolean :as_default, null: false, default: false

      t.timestamps
    end
  add_index :addresses, [ :user_id, :as_default ]
  add_index :addresses, :postal_code
  end
end
