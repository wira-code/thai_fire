class AddFlagsToProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :featured, :boolean
    add_column :products, :bestseller, :boolean
  end
end
