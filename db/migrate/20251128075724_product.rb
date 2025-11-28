class Product < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :min_qty_type, :string
    add_column :products, :unit_description, :string
  end
end
