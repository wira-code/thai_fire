class CreatePayments < ActiveRecord::Migration[8.1]
  def change
    create_table :payments do |t|
      t.references :order, null: false, foreign_key: true,
                index: { unique: true }
      t.string :provider, null: false
      t.string :provider_payment_id
      t.integer :amount_cents, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.datetime :paid_at

      t.timestamps
    end
  add_index :payments, [ :provider, :provider_payment_id ], unique: true, where: "provider_payment_id IS NOT NULL"
  end
end
