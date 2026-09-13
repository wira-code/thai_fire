class CreateReservations < ActiveRecord::Migration[8.1]
  def change
    create_table :reservations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :email
      t.string :phone
      t.date :reservation_date
      t.time :reservation_time
      t.integer :guests
      t.boolean :status

      t.timestamps
    end
  end
end
