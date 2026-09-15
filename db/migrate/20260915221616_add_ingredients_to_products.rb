class AddIngredientsToProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :ingredients, :text
  end
end
