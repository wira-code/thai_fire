class CreateOptionChoices < ActiveRecord::Migration[8.1]
  def change
    create_table :option_choices do |t|
      t.references :option, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :price_cents, null: false, default: 0
      t.integer :position, null: false, default: 0

      t.timestamps
    end
  add_index :option_choices, [ :option_id, :name ], unique: true
  add_index :option_choices, [ :option_id, :position ]
  end
end
