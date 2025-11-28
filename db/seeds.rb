# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'open-uri'

User.destroy_all
Product.destroy_all
Chat.destroy_all
Message.destroy_all
puts "All products deleted: Procduct count = #{Product.count}"

example_products = [
  {
  "name": "Organic Apples",
  "description": "Fresh, crisp red apples, ideal for snacking or baking.",
  "category": "Fruits",
  "minimum_qty": 0.5,
  "min_qty_type": "kg",
  "price_unit": 1.99,
  "unit_description": "pack of 4",
  "price_kg": 3.98,
  "country_of_origin": "United States",
  "days_until_expired": 14,
  "image_url": "https://cdn.pixabay.com/photo/2016/09/29/08/33/apple-1702316_1280.jpg"
  },
  {
  "name": "Whole Milk",
  "description": "Pasteurized full-fat milk from grass-fed cows, 1 gallon jug.",
  "category": "Dairy",
  "minimum_qty": 1.0,
  "min_qty_type": "l",
  "price_unit": 3.49,
  "unit_description": "tetra pack of 1 l",
  "price_kg": 3.49,
  "country_of_origin": "United States",
  "days_until_expired": 21,
  "image_url": "https://static.apolonia.com/fotos/produtos/21/211869_01_24-02-2025_g.jpg"
  },
  {
  "name": "White Bread",
  "description": "Sliced white loaf bread, soft and fresh for sandwiches.",
  "category": "Bakery",
  "minimum_qty": 1.0,
  "min_qty_type": "piece",
  "price_unit": 2.29,
  "unit_description": "one piece",
  "price_kg": 4.58,
  "country_of_origin": "Canada",
  "days_until_expired": 7,
  "image_url": "https://www.seriouseats.com/thmb/LoXQL7Yp_uXxtipH8cCp_LGVg5E=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/__opt__aboutcom__coeus__resources__content_migration__serious_eats__seriouseats.com__recipes__images__2014__08__20140810-workhorse-bread-vicky-wasik-3-3a86ee51da2e4a7b8239ceb62d8d8d17.jpg"
  },
  {
  "name": "Canned Tomatoes",
  "description": "Diced tomatoes in juice, no added salt, 28 oz can.",
  "category": "Canned Goods",
  "minimum_qty": 1,
  "min_qty_type": "piece",
  "price_unit": 1.19,
  "unit_description": "can of 750 g",
  "price_kg": 1.68,
  "country_of_origin": "Italy",
  "days_until_expired": 1095,
  "image_url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ1wxgvJ-J3V9P9yk6OH5dMuh7YkIwceWtDXA&s"
  },
  {
  "name": "Chicken Breast",
  "description": "Boneless, skinless chicken breasts, fresh pack of 1 lb.",
  "category": "Meat",
  "minimum_qty": 1,
  "min_qty_type": "piece",
  "price_unit": 4.99,
  "unit_description": "pack of 2 breasts",
  "price_kg": 11.0,
  "country_of_origin": "United States",
  "days_until_expired": 5,
  "image_url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZ5CNJPuS3s3iQLhK8V0RRaNmuPuEu8_NOJw&s"
  },
  {
  "name": "Broccoli",
  "description": "Fresh green broccoli heads, rich in vitamins, per bunch.",
  "category": "Vegetables",
  "minimum_qty": 0.3,
  "min_qty_type": "kg",
  "price_unit": 1.79,
  "unit_description": "quater of a broccoli",
  "price_kg": 5.97,
  "country_of_origin": "Mexico",
  "days_until_expired": 10,
  "image_url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR3jhpPKRJxljeORwNbUy0XC9aS9qERhtykJw&s"
  },
  {
  "name": "Pasta Spaghetti",
  "description": "Dry durum wheat spaghetti, 16 oz package.",
  "category": "Pasta",
  "minimum_qty": 1,
  "min_qty_type": "piece",
  "price_unit": 1.49,
  "unit_description": "pack of 250 g",
  "price_kg": 3.31,
  "country_of_origin": "Italy",
  "days_until_expired": 365,
  "image_url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSHA0RiYpubnUda21AcIuf-pldi-URLvzon-w&s"
  },
  {
  "name": "Cheddar Cheese",
  "description": "Aged sharp cheddar cheese block, 8 oz.",
  "category": "Dairy",
  "minimum_qty": 0.23,
  "min_qty_type": "kg",
  "price_unit": 2.99,
  "unit_description": "slice of 150 g",
  "price_kg": 14.95,
  "country_of_origin": "Ireland",
  "days_until_expired": 28,
  "image_url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGL_9cC4kM0DfB4YpNT2wgbtmMubJV9YL8EA&s"
  },
  {
  "name": "Bananas",
  "description": "Ripe yellow bananas, bunch of 5-6, naturally sweet.",
  "category": "Fruits",
  "minimum_qty": 0.5,
  "min_qty_type": "kg",
  "price_unit": 0.59,
  "unit_description": "pack of 500",
  "price_kg": 1.18,
  "country_of_origin": "Madeira, Portugal",
  "days_until_expired": 7,
  "image_url": "https://www.continente.pt/dw/image/v2/BDVS_PRD/on/demandware.static/-/Sites-col-master-catalog/default/dwd4c8df36/images/col/207/2076480-frente.jpg?sw=2000&sh=2000"
  },
  {
  "name": "Orange Juice",
  "description": "Fresh squeezed orange juice, no pulp, 64 oz carton.",
  "category": "Beverages",
  "minimum_qty": 1,
  "min_qty_type": "l",
  "price_unit": 3.99,
  "unit_description": "bottle of 1 l",
  "price_kg": 2.11,
  "country_of_origin": "United States",
  "days_until_expired": 14,
  "image_url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnDyg9G8txGuNdWvzJERP_fNeF0ChN8EBceA&s"
  }
]

example_products.each do |example_product|
  product = Product.new
  product.name = example_product[:name]
  product.description = example_product[:description]
  product.category = example_product[:category]
  product.minimum_qty = example_product[:minimum_qty]
  product.min_qty_type = example_product[:min_qty_type]
  product.price_unit = example_product[:price_unit]
  product.unit_description = example_product[:unit_description]
  product.price_kg = example_product[:price_kg]
  product.country_of_origin = example_product[:country_of_origin]
  product.days_until_expired = example_product[:days_until_expired]
  file = URI.parse(example_product[:image_url]).open
  product.photo.attach(io: file, filename: "#{example_product[:name]}_#{example_product[:category]}.jpg", content_type: "image/jpg")
  product.save!
end

puts "created #{Product.count} products"
