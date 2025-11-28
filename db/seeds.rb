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
    "minimum_qty": 1,
    "min_qty_type": "pack",  # sold per pack
    "price_unit": 1.99,      # price per pack
    "unit_description": "pack of 4 apples (≈0.5 kg)",
    "price_kg": 3.98,        # 1.99 / 0.5
    "country_of_origin": "United States",
    "days_until_expired": 14,
    "image_url": "https://cdn.pixabay.com/photo/2016/09/29/08/33/apple-1702316_1280.jpg"
  },
  {
    "name": "Whole Milk",
    "description": "Pasteurized full-fat milk from grass-fed cows, 1 gallon jug.",
    "category": "Dairy",
    "minimum_qty": 1.0,
    "min_qty_type": "l",    # sold per liter
    "price_unit": 3.49,     # price per 1 l carton
    "unit_description": "tetra pack of 1 l",
    "price_kg": 3.49,       # ~1 kg per liter
    "country_of_origin": "United States",
    "days_until_expired": 21,
    "image_url": "https://static.apolonia.com/fotos/produtos/21/211869_01_24-02-2025_g.jpg"
  },
  {
    "name": "White Bread",
    "description": "Sliced white loaf bread, soft and fresh for sandwiches.",
    "category": "Bakery",
    "minimum_qty": 1.0,
    "min_qty_type": "piece",   # one loaf
    "price_unit": 2.29,        # price per loaf
    "unit_description": "one piece",
    "price_kg": 4.58,          # ~0.5 kg loaf
    "country_of_origin": "Canada",
    "days_until_expired": 7,
    "image_url": "https://www.seriouseats.com/thmb/LoXQL7Yp_uXxtipH8cCp_LGVg5E=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/__opt__aboutcom__coeus__resources__content_migration__serious_eats__seriouseats.com__recipes__images__2014__08__20140810-workhorse-bread-vicky-wasik-3-3a86ee51da2e4a7b8239ceb62d8d8d17.jpg"
  },
  {
    "name": "Canned Tomatoes",
    "description": "Diced tomatoes in juice, no added salt, 28 oz can.",
    "category": "Canned Goods",
    "minimum_qty": 1,
    "min_qty_type": "can",     # sold per can
    "price_unit": 1.19,        # price per 750 g can
    "unit_description": "can of 750 g",
    "price_kg": 1.59,          # 1.19 / 0.75
    "country_of_origin": "Italy",
    "days_until_expired": 1095,
    "image_url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ1wxgvJ-J3V9P9yk6OH5dMuh7YkIwceWtDXA&s"
  },
  {
    "name": "Chicken Breast",
    "description": "Boneless, skinless chicken breasts, fresh pack of 1 lb.",
    "category": "Meat",
    "minimum_qty": 1,
    "min_qty_type": "pack",     # sold per pack
    "price_unit": 4.99,         # price per pack of 2
    "unit_description": "pack of 2 breasts (≈1 lb)",
    "price_kg": 11.0,           # based on ~0.454 kg per pack
    "country_of_origin": "United States",
    "days_until_expired": 5,
    "image_url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZ5CNJPuS3s3iQLhK8V0RRaNmuPuEu8_NOJw&s"
  },
  {
    "name": "Broccoli",
    "description": "Fresh green broccoli heads, rich in vitamins, per bunch.",
    "category": "Vegetables",
    "minimum_qty": 0.3,
    "min_qty_type": "kg",      # sold by weight
    "price_unit": 5.97,        # price per kg
    "unit_description": "per kg",
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
    "min_qty_type": "pack",     # sold per pack
    "price_unit": 1.49,         # price per 250 g pack
    "unit_description": "pack of 250 g",
    "price_kg": 5.96,           # 1.49 / 0.25
    "country_of_origin": "Italy",
    "days_until_expired": 365,
    "image_url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSHA0RiYpubnUda21AcIuf-pldi-URLvzon-w&s"
  },
  {
    "name": "Cheddar Cheese",
    "description": "Aged sharp cheddar cheese block, 8 oz.",
    "category": "Dairy",
    "minimum_qty": 1,
    "min_qty_type": "slice",    # sold per slice/pack
    "price_unit": 2.99,         # price per 150 g slice
    "unit_description": "slice of 150 g",
    "price_kg": 19.93,          # 2.99 / 0.15
    "country_of_origin": "Ireland",
    "days_until_expired": 28,
    "image_url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGL_9cC4kM0DfB4YpNT2wgbtmMubJV9YL8EA&s"
  },
  {
    "name": "Bananas",
    "description": "Ripe yellow bananas, bunch of 5-6, naturally sweet.",
    "category": "Fruits",
    "minimum_qty": 1,
    "min_qty_type": "pack",     # sold per 500 g pack
    "price_unit": 0.59,         # price per 500 g pack
    "unit_description": "pack of 500 g",
    "price_kg": 1.18,           # 0.59 / 0.5
    "country_of_origin": "Madeira, Portugal",
    "days_until_expired": 7,
    "image_url": "https://www.continente.pt/dw/image/v2/BDVS_PRD/on/demandware.static/-/Sites-col-master-catalog/default/dwd4c8df36/images/col/207/2076480-frente.jpg?sw=2000&sh=2000"
  },
  {
    "name": "Orange Juice",
    "description": "Fresh squeezed orange juice, no pulp, 64 oz carton.",
    "category": "Beverages",
    "minimum_qty": 1,
    "min_qty_type": "l",        # sold per liter/bottle
    "price_unit": 3.99,         # price per 1 l bottle
    "unit_description": "bottle of 1 l",
    "price_kg": 3.99,           # ~1 kg per liter
    "country_of_origin": "United States",
    "days_until_expired": 14,
    "image_url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnDyg9G8txGuNdWvzJERP_fNeF0ChN8EBceA&s"
  },
  { #We start here to fix the URL DOWN!!!!!!
    "name": "Organic Apples",
    "description": "Fresh, crisp red apples, ideal for snacking or baking.",
    "category": "Fruits",
    "minimum_qty": 1,
    "min_qty_type": "pack",
    "price_unit": 1.99,
    "unit_description": "pack of 4 apples (≈0.5 kg)",
    "price_kg": 3.98,
    "country_of_origin": "United States",
    "days_until_expired": 14,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Bananas",
    "description": "Ripe yellow bananas, naturally sweet, perfect for breakfast.",
    "category": "Fruits",
    "minimum_qty": 0.5,
    "min_qty_type": "kg",
    "price_unit": 1.49,
    "unit_description": "loose, sold per kg",
    "price_kg": 1.49,
    "country_of_origin": "Ecuador",
    "days_until_expired": 7,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Navel Oranges",
    "description": "Juicy seedless navel oranges, great for juicing.",
    "category": "Fruits",
    "minimum_qty": 1.0,
    "min_qty_type": "kg",
    "price_unit": 2.39,
    "unit_description": "loose, sold per kg",
    "price_kg": 2.39,
    "country_of_origin": "Spain",
    "days_until_expired": 10,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Strawberries",
    "description": "Sweet ripe strawberries in a ventilated punnet.",
    "category": "Fruits",
    "minimum_qty": 1,
    "min_qty_type": "pack",
    "price_unit": 3.29,
    "unit_description": "pack of 400 g",
    "price_kg": 8.22,
    "country_of_origin": "Portugal",
    "days_until_expired": 4,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Blueberries",
    "description": "Fresh blueberries, rich in antioxidants.",
    "category": "Fruits",
    "minimum_qty": 1,
    "min_qty_type": "pack",
    "price_unit": 2.99,
    "unit_description": "pack of 200 g",
    "price_kg": 14.95,
    "country_of_origin": "Poland",
    "days_until_expired": 7,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Grapes",
    "description": "Seedless green grapes, crisp and refreshing.",
    "category": "Fruits",
    "minimum_qty": 0.5,
    "min_qty_type": "kg",
    "price_unit": 3.99,
    "unit_description": "loose, sold per kg",
    "price_kg": 3.99,
    "country_of_origin": "Italy",
    "days_until_expired": 6,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Avocados",
    "description": "Creamy Hass avocados, ready to eat.",
    "category": "Fruits",
    "minimum_qty": 1,
    "min_qty_type": "pack",
    "price_unit": 2.79,
    "unit_description": "pack of 2 avocados (≈0.35 kg)",
    "price_kg": 7.97,
    "country_of_origin": "Mexico",
    "days_until_expired": 5,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Cherry Tomatoes",
    "description": "Sweet cherry tomatoes, ideal for salads.",
    "category": "Vegetables",
    "minimum_qty": 1,
    "min_qty_type": "pack",
    "price_unit": 1.89,
    "unit_description": "pack of 250 g",
    "price_kg": 7.56,
    "country_of_origin": "Morocco",
    "days_until_expired": 7,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Broccoli",
    "description": "Fresh green broccoli heads, rich in vitamins.",
    "category": "Vegetables",
    "minimum_qty": 0.3,
    "min_qty_type": "kg",
    "price_unit": 3.49,
    "unit_description": "sold per kg",
    "price_kg": 3.49,
    "country_of_origin": "Spain",
    "days_until_expired": 7,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Carrots",
    "description": "Crunchy orange carrots, perfect for cooking or snacking.",
    "category": "Vegetables",
    "minimum_qty": 0.5,
    "min_qty_type": "kg",
    "price_unit": 1.09,
    "unit_description": "loose, sold per kg",
    "price_kg": 1.09,
    "country_of_origin": "Netherlands",
    "days_until_expired": 21,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Red Onions",
    "description": "Mild red onions, great raw or cooked.",
    "category": "Vegetables",
    "minimum_qty": 0.5,
    "min_qty_type": "kg",
    "price_unit": 1.39,
    "unit_description": "loose, sold per kg",
    "price_kg": 1.39,
    "country_of_origin": "Spain",
    "days_until_expired": 30,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Potatoes",
    "description": "All-purpose white potatoes, ideal for boiling or roasting.",
    "category": "Vegetables",
    "minimum_qty": 1,
    "min_qty_type": "bag",
    "price_unit": 2.49,
    "unit_description": "bag of 2 kg",
    "price_kg": 1.25,
    "country_of_origin": "France",
    "days_until_expired": 30,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Mixed Salad Leaves",
    "description": "Ready-to-eat salad mix, washed and dried.",
    "category": "Vegetables",
    "minimum_qty": 1,
    "min_qty_type": "pack",
    "price_unit": 1.79,
    "unit_description": "pack of 150 g",
    "price_kg": 11.93,
    "country_of_origin": "Portugal",
    "days_until_expired": 4,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Cucumber",
    "description": "Fresh cucumbers, great for salads and snacking.",
    "category": "Vegetables",
    "minimum_qty": 1,
    "min_qty_type": "piece",
    "price_unit": 0.79,
    "unit_description": "one cucumber (≈0.35 kg)",
    "price_kg": 2.26,
    "country_of_origin": "Spain",
    "days_until_expired": 5,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Whole Chicken",
    "description": "Fresh whole chicken, great for roasting.",
    "category": "Meat",
    "minimum_qty": 1.0,
    "min_qty_type": "kg",
    "price_unit": 4.29,
    "unit_description": "sold per kg",
    "price_kg": 4.29,
    "country_of_origin": "Portugal",
    "days_until_expired": 5,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Chicken Breast Fillets",
    "description": "Boneless, skinless chicken breast fillets.",
    "category": "Meat",
    "minimum_qty": 1,
    "min_qty_type": "pack",
    "price_unit": 4.49,
    "unit_description": "pack of 500 g",
    "price_kg": 8.98,
    "country_of_origin": "Brazil",
    "days_until_expired": 5,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Ground Beef 10% Fat",
    "description": "Fresh minced beef, 10% fat.",
    "category": "Meat",
    "minimum_qty": 1,
    "min_qty_type": "pack",
    "price_unit": 4.99,
    "unit_description": "pack of 500 g",
    "price_kg": 9.98,
    "country_of_origin": "Ireland",
    "days_until_expired": 3,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Pork Chops",
    "description": "Bone-in pork chops, tender and juicy.",
    "category": "Meat",
    "minimum_qty": 0.5,
    "min_qty_type": "kg",
    "price_unit": 5.29,
    "unit_description": "sold per kg",
    "price_kg": 5.29,
    "country_of_origin": "Spain",
    "days_until_expired": 4,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Smoked Bacon",
    "description": "Sliced smoked pork bacon.",
    "category": "Meat",
    "minimum_qty": 1,
    "min_qty_type": "pack",
    "price_unit": 2.49,
    "unit_description": "pack of 200 g",
    "price_kg": 12.45,
    "country_of_origin": "Germany",
    "days_until_expired": 21,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Fresh Salmon Fillet",
    "description": "Boneless salmon fillet, rich in omega-3.",
    "category": "Fish",
    "minimum_qty": 0.3,
    "min_qty_type": "kg",
    "price_unit": 16.99,
    "unit_description": "sold per kg",
    "price_kg": 16.99,
    "country_of_origin": "Norway",
    "days_until_expired": 3,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Frozen Cod Loins",
    "description": "Individually frozen cod loins.",
    "category": "Fish",
    "minimum_qty": 1,
    "min_qty_type": "pack",
    "price_unit": 6.49,
    "unit_description": "pack of 600 g",
    "price_kg": 10.82,
    "country_of_origin": "Iceland",
    "days_until_expired": 365,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Canned Tuna in Olive Oil",
    "description": "Tuna chunks preserved in olive oil.",
    "category": "Canned Goods",
    "minimum_qty": 1,
    "min_qty_type": "can",
    "price_unit": 1.49,
    "unit_description": "can of 120 g (90 g drained)",
    "price_kg": 12.42,
    "country_of_origin": "Spain",
    "days_until_expired": 1095,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Canned Chickpeas",
    "description": "Cooked chickpeas in brine.",
    "category": "Canned Goods",
    "minimum_qty": 1,
    "min_qty_type": "can",
    "price_unit": 0.79,
    "unit_description": "can of 400 g (240 g drained)",
    "price_kg": 1.98,
    "country_of_origin": "Italy",
    "days_until_expired": 1095,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Tomato Passata",
    "description": "Smooth strained tomatoes, ideal for sauces.",
    "category": "Canned Goods",
    "minimum_qty": 1,
    "min_qty_type": "bottle",
    "price_unit": 1.39,
    "unit_description": "glass bottle of 700 g",
    "price_kg": 1.99,
    "country_of_origin": "Italy",
    "days_until_expired": 365,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Spaghetti Pasta",
    "description": "Dry durum wheat spaghetti.",
    "category": "Pasta & Rice",
    "minimum_qty": 1,
    "min_qty_type": "pack",
    "price_unit": 1.19,
    "unit_description": "pack of 500 g",
    "price_kg": 2.38,
    "country_of_origin": "Italy",
    "days_until_expired": 730,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Basmati Rice",
    "description": "Aromatic long-grain basmati rice.",
    "category": "Pasta & Rice",
    "minimum_qty": 1,
    "min_qty_type": "bag",
    "price_unit": 2.69,
    "unit_description": "bag of 1 kg",
    "price_kg": 2.69,
    "country_of_origin": "India",
    "days_until_expired": 730,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Whole Wheat Penne",
    "description": "Whole grain penne pasta.",
    "category": "Pasta & Rice",
    "minimum_qty": 1,
    "min_qty_type": "pack",
    "price_unit": 1.39,
    "unit_description": "pack of 500 g",
    "price_kg": 2.78,
    "country_of_origin": "Italy",
    "days_until_expired": 730,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "All-Purpose Flour",
    "description": "Wheat flour suitable for baking and cooking.",
    "category": "Baking",
    "minimum_qty": 1,
    "min_qty_type": "bag",
    "price_unit": 0.99,
    "unit_description": "bag of 1 kg",
    "price_kg": 0.99,
    "country_of_origin": "France",
    "days_until_expired": 365,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Granulated Sugar",
    "description": "White granulated sugar for baking and sweetening.",
    "category": "Baking",
    "minimum_qty": 1,
    "min_qty_type": "bag",
    "price_unit": 1.19,
    "unit_description": "bag of 1 kg",
    "price_kg": 1.19,
    "country_of_origin": "France",
    "days_until_expired": 730,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Brown Sugar",
    "description": "Soft light brown sugar, ideal for desserts.",
    "category": "Baking",
    "minimum_qty": 1,
    "min_qty_type": "bag",
    "price_unit": 1.49,
    "unit_description": "bag of 500 g",
    "price_kg": 2.98,
    "country_of_origin": "Germany",
    "days_until_expired": 365,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Organic Oats",
    "description": "Rolled oats, perfect for porridge.",
    "category": "Breakfast",
    "minimum_qty": 1,
    "min_qty_type": "bag",
    "price_unit": 2.19,
    "unit_description": "bag of 1 kg",
    "price_kg": 2.19,
    "country_of_origin": "Finland",
    "days_until_expired": 365,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Corn Flakes Cereal",
    "description": "Crispy corn flakes breakfast cereal.",
    "category": "Breakfast",
    "minimum_qty": 1,
    "min_qty_type": "box",
    "price_unit": 2.59,
    "unit_description": "box of 500 g",
    "price_kg": 5.18,
    "country_of_origin": "Germany",
    "days_until_expired": 365,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Greek Yogurt Natural",
    "description": "Thick strained natural Greek yogurt, 10% fat.",
    "category": "Dairy",
    "minimum_qty": 1,
    "min_qty_type": "tub",
    "price_unit": 1.99,
    "unit_description": "tub of 500 g",
    "price_kg": 3.98,
    "country_of_origin": "Greece",
    "days_until_expired": 21,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Mozzarella Cheese",
    "description": "Fresh mozzarella cheese ball in brine.",
    "category": "Dairy",
    "minimum_qty": 1,
    "min_qty_type": "pack",
    "price_unit": 0.99,
    "unit_description": "pack of 125 g",
    "price_kg": 7.92,
    "country_of_origin": "Italy",
    "days_until_expired": 14,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Cheddar Cheese Block",
    "description": "Mature cheddar cheese block.",
    "category": "Dairy",
    "minimum_qty": 1,
    "min_qty_type": "pack",
    "price_unit": 3.19,
    "unit_description": "block of 250 g",
    "price_kg": 12.76,
    "country_of_origin": "United Kingdom",
    "days_until_expired": 60,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Butter Unsalted",
    "description": "Creamy unsalted butter.",
    "category": "Dairy",
    "minimum_qty": 1,
    "min_qty_type": "pack",
    "price_unit": 2.29,
    "unit_description": "pack of 250 g",
    "price_kg": 9.16,
    "country_of_origin": "Ireland",
    "days_until_expired": 90,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Fresh Eggs",
    "description": "Free-range medium eggs.",
    "category": "Dairy & Eggs",
    "minimum_qty": 1,
    "min_qty_type": "box",
    "price_unit": 2.79,
    "unit_description": "box of 12 eggs (≈0.7 kg)",
    "price_kg": 3.99,
    "country_of_origin": "Portugal",
    "days_until_expired": 21,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "White Sandwich Bread",
    "description": "Soft sliced white sandwich bread.",
    "category": "Bakery",
    "minimum_qty": 1,
    "min_qty_type": "loaf",
    "price_unit": 1.49,
    "unit_description": "loaf of 700 g",
    "price_kg": 2.13,
    "country_of_origin": "Portugal",
    "days_until_expired": 5,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Whole Wheat Bread",
    "description": "Sliced whole wheat bread.",
    "category": "Bakery",
    "minimum_qty": 1,
    "min_qty_type": "loaf",
    "price_unit": 1.69,
    "unit_description": "loaf of 700 g",
    "price_kg": 2.41,
    "country_of_origin": "Portugal",
    "days_until_expired": 5,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Croissants",
    "description": "Buttery flaky croissants.",
    "category": "Bakery",
    "minimum_qty": 1,
    "min_qty_type": "pack",
    "price_unit": 2.49,
    "unit_description": "pack of 4 croissants (≈240 g)",
    "price_kg": 10.38,
    "country_of_origin": "France",
    "days_until_expired": 3,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Orange Juice 100%",
    "description": "Chilled 100% orange juice, not from concentrate.",
    "category": "Beverages",
    "minimum_qty": 1,
    "min_qty_type": "bottle",
    "price_unit": 2.49,
    "unit_description": "bottle of 1 l",
    "price_kg": 2.49,
    "country_of_origin": "Spain",
    "days_until_expired": 14,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Apple Juice",
    "description": "Clear apple juice from concentrate.",
    "category": "Beverages",
    "minimum_qty": 1,
    "min_qty_type": "bottle",
    "price_unit": 1.79,
    "unit_description": "bottle of 1 l",
    "price_kg": 1.79,
    "country_of_origin": "Germany",
    "days_until_expired": 120,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Sparkling Water",
    "description": "Carbonated mineral water.",
    "category": "Beverages",
    "minimum_qty": 1,
    "min_qty_type": "bottle",
    "price_unit": 0.59,
    "unit_description": "bottle of 1.5 l",
    "price_kg": 0.39,
    "country_of_origin": "Portugal",
    "days_until_expired": 365,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Cola Drink",
    "description": "Carbonated cola soft drink.",
    "category": "Beverages",
    "minimum_qty": 1,
    "min_qty_type": "bottle",
    "price_unit": 1.29,
    "unit_description": "bottle of 1.5 l",
    "price_kg": 0.86,
    "country_of_origin": "Netherlands",
    "days_until_expired": 365,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Frozen Peas",
    "description": "Tender green peas, quick frozen.",
    "category": "Frozen",
    "minimum_qty": 1,
    "min_qty_type": "bag",
    "price_unit": 1.59,
    "unit_description": "bag of 750 g",
    "price_kg": 2.12,
    "country_of_origin": "Belgium",
    "days_until_expired": 730,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Vanilla Ice Cream",
    "description": "Classic vanilla ice cream.",
    "category": "Frozen",
    "minimum_qty": 1,
    "min_qty_type": "tub",
    "price_unit": 2.99,
    "unit_description": "tub of 900 ml (≈450 g)",
    "price_kg": 6.64,
    "country_of_origin": "Spain",
    "days_until_expired": 365,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Potato Chips Salted",
    "description": "Crispy salted potato chips.",
    "category": "Snacks",
    "minimum_qty": 1,
    "min_qty_type": "bag",
    "price_unit": 1.29,
    "unit_description": "bag of 150 g",
    "price_kg": 8.6,
    "country_of_origin": "Spain",
    "days_until_expired": 120,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Dark Chocolate 70%",
    "description": "Dark chocolate bar with 70% cocoa.",
    "category": "Snacks & Sweets",
    "minimum_qty": 1,
    "min_qty_type": "bar",
    "price_unit": 1.89,
    "unit_description": "bar of 100 g",
    "price_kg": 18.9,
    "country_of_origin": "Belgium",
    "days_until_expired": 365,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Olive Oil Extra Virgin",
    "description": "Cold-pressed extra virgin olive oil.",
    "category": "Pantry",
    "minimum_qty": 1,
    "min_qty_type": "bottle",
    "price_unit": 6.99,
    "unit_description": "bottle of 750 ml (≈0.69 kg)",
    "price_kg": 10.13,
    "country_of_origin": "Portugal",
    "days_until_expired": 730,
    "image_url": "https://example.com/image_placeholder.jpg"
  },
  {
    "name": "Blossom Honey",
    "description": "Golden blossom honey, smooth and mildly floral.",
    "category": "Pantry",
    "minimum_qty": 1,
    "min_qty_type": "jar",
    "price_unit": 4.49,
    "unit_description": "glass jar of 500 g",
    "price_kg": 8.98,
    "country_of_origin": "Hungary",
    "days_until_expired": 730,
    "image_url": "https://example.com/image_placeholder.jpg"
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
