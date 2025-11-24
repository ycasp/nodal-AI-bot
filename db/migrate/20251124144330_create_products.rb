class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.string :category
      t.float :minimum_qty
      t.float :price_unit
      t.float :price_kg
      t.string :country_of_origin
      t.integer :days_until_expired

      t.timestamps
    end
  end
end
