class CreateDeliveryZones < ActiveRecord::Migration[8.1]
  def change
    create_table :delivery_zones do |t|
      t.string :name, null: false
      t.string :postal_code, null: false
      t.integer :delivery_fee_cents, null: false, default: 0
      t.integer :minimun_order_cents, null: false, default: 0
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  add_index :delivery_zones, :postal_code
  add_index :delivery_zones, :active
  add_index :delivery_zones, [ :postal_code, :active ]
  end
end
