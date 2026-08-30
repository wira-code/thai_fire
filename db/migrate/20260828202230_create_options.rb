class CreateOptions < ActiveRecord::Migration[8.1]
  def change
    create_table :options do |t|
      t.string :name, null: false
      t.boolean :required, null: false, default: false
      t.boolean :multiple, null: false, default: false
      t.integer :position, null: false, default: 0

      t.timestamps
    end
  add_index :options, :name, unique: true
  add_index :options, :position
  end
end
