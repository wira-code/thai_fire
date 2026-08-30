class CreateCarts < ActiveRecord::Migration[8.1]
  def change
    create_table :carts do |t|
      t.references :user, null: true, foreign_key: true
      # null: true เพื่อรองรับ guest

      t.timestamps
    end
  end
end
