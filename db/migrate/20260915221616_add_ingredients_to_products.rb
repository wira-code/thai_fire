class AddIngredientsToProducts < ActiveRecord::Migration[8.1]
  def change
    unless column_exists?(:products, :ingredients)
      add_column :products, :ingredients, :text
    end
  end
end
