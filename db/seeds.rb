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
    "image_url": "https://m.media-amazon.com/images/I/71WJR4J0uUL.jpg"
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
    "image_url": "https://papayaexpress.com/cdn/shop/files/0003338320030_1500x.webp?v=1700154615"
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
    "image_url": "https://bfasset.costco-static.com/U447IH35/as/gkbkg34jks75jtnvtkvwx/57554__1psd?auto=webp&format=jpg&width=350&height=350&fit=bounds&canvas=350,350"
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
    "image_url": "https://www.shutterstock.com/image-photo/box-american-seedless-green-grapes-260nw-1570765486.jpg"
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
    "image_url": "https://media.gettyimages.com/id/559226989/photo/close-up-of-two-whole-avocados.jpg?s=612x612&w=0&k=20&c=Aset4WeCtC481I8il8EAQngLZRoiLL3a91rQjZLzU54="
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
    "image_url": "https://theproduceguyz.com/cdn/shop/files/grape_tomatoe_2025.png?v=1736796523"
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
    "image_url": "https://thumbs.dreamstime.com/b/young-carrots-package-table-vegetable-group-143689253.jpg"
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
    "image_url": "https://m.media-amazon.com/images/I/81HAyJOUT4L.jpg"
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
    "image_url": "https://images.heb.com/is/image/HEBGrocery/000475971-1?hei=360&wid=360"
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
    "image_url": "https://organicdeliverycompany.co.uk/cdn/shop/files/salad-mixed-pack-200g-459890_530x@2x.jpg?v=1730162700"
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
    "image_url": "https://media.gettyimages.com/id/1665711648/photo/basket-of-fresh-picked-cucumbers-from-the-garden.jpg?s=612x612&w=0&k=20&c=QS5N06Qb6Uh1gqlhGRpYchtQXKTCRmkfKSWXNzkOrsQ="
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
    "image_url": "https://thumbs.dreamstime.com/b/fresh-raw-chicken-whole-stuffed-lemon-spices-cooking-wooden-board-top-view-62109794.jpg"
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
    "image_url": "https://m.media-amazon.com/images/I/413-ZcUD24L.jpg"
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
    "image_url": "https://images.albertsons-media.com/is/image/ABS/970334359?$ng-ecom-pdp-mobile$&defaultImage=Not_Available"
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
    "image_url": "https://i5.walmartimages.com/seo/Butt-Steak-Bone-in-Family-Pack-Pork-3-1-5-1-lb-Fresh_548d290c-8cf7-4417-b420-ff43a600e51e.88dc11a6b97cd0f22a03b0158b53d431.jpeg?odnHeight=580&odnWidth=580&odnBg=FFFFFF"
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
    "image_url": "https://m.media-amazon.com/images/I/513AslcWP9L.jpg"
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
    "image_url": "https://media.gettyimages.com/id/1930253808/photo/vacuum-packed-salmon-fillet-slices-isolated-on-white.jpg?s=612x612&w=0&k=20&c=quZXDVM7rMOg-MxMOMNn8quP8N8Q5racZe4NVOB7CKk="
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
    "image_url": "https://preferredmeatsinc.com/wp-content/uploads/2017/07/cod-loins-frozen-scaled.jpg"
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
    "image_url": "https://cdn.apartmenttherapy.info/image/upload/f_auto,q_auto:eco,w_730/tk/photo/2025/05-2025/2025-05-taste-test-canned-tuna/2025-05-taste-test-canned-tuna-cento"
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
    "image_url": "https://m.media-amazon.com/images/I/81z7eIJ05ZL._SY879_.jpg"
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
    "image_url": "https://ettopastificio.com/cdn/shop/products/conchigliete1lbbag.jpg?v=1736299008&width=1080"
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
    "image_url": "https://m.media-amazon.com/images/I/61LB+r1beKL._SX679_.jpg"
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
    "image_url": "https://m.media-amazon.com/images/I/61eQb1sUyFL.jpg"
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
    "image_url": "https://m.media-amazon.com/images/I/815U9dG7tpL.jpg"
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
    "image_url": "https://m.media-amazon.com/images/I/71cdAu7Ko4L.jpg"
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
    "image_url": "https://a1coffee.net/cdn/shop/products/Granulated_White_Sugar.jpg?v=1740561038&width=480"
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
    "image_url": "https://i5.walmartimages.com/seo/Domino-Premium-Pure-Cane-Light-Brown-Sugar-2-lb-Zipper-Pak_81b88e8b-5d1b-4761-b8d8-fd0027099a30.3e96d2748feb0670bb970fdaa1f49afe.jpeg?odnHeight=580&odnWidth=580&odnBg=FFFFFF"
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
    "image_url": "https://m.media-amazon.com/images/S/assets.wholefoodsmarket.com/PIE/product/41f--ApsbaL._FMwebp__SR600,600_.jpg"
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
    "image_url": "https://m.media-amazon.com/images/I/5162b9Os-tL.jpg"
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
    "image_url": "https://i5.walmartimages.com/seo/Chobani-Non-Fat-Greek-Yogurt-Zero-Sugar-Vanilla-32-Oz-Tub_f60f55cd-d555-49b4-80db-43d0a00107ad.697904afb9189d9b3d20fb7cdfb27eb6.jpeg?odnHeight=320&odnWidth=320&odnBg=FFFFFF"
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
    "image_url": "https://i5.walmartimages.com/seo/Kraft-Mozzarella-Shredded-Cheese-16-oz-Bag_4449d53c-9662-456b-ac75-ba64b0928766.fe8a80118579d2a845356e3c0f843034.png?odnHeight=580&odnWidth=580&odnBg=FFFFFF"
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
    "image_url": "https://storage.googleapis.com/images-lnb-prd-8936dd0.lnb.prd.v8.commerce.mi9cloud.com/product-images/cell/00273009000009.png"
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
    "image_url": "https://cdn.thewirecutter.com/wp-content/media/2024/10/butter-2048px-3623.jpg?auto=webp&quality=75&width=1024"
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
    "image_url": "https://media.gettyimages.com/id/171206679/photo/egg-carton-isolated-clipping-path.jpg?s=612x612&w=0&k=20&c=NXiThdkBiG9WMptlc5SpwhxR3iriKn2gnJHztTRQsgU="
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
    "image_url": "https://m.media-amazon.com/images/I/81jmXcuPxSL.jpg"
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
    "image_url": "https://m.media-amazon.com/images/I/51YVt8YUEtL.jpg"
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
    "image_url": "https://i5.walmartimages.com/seo/Marketside-All-Butter-Whole-Croissants-9-17-oz-4-Count_b29c87d7-df65-45cc-abb8-a0ef30dce215.916e35676cedc455e187ad61d0d021a5.jpeg?odnHeight=580&odnWidth=580&odnBg=FFFFFF"
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
    "image_url": "https://i5.walmartimages.com/seo/Simply-Orange-Pulp-Free-Orange-Juice-46-fl-oz-Bottle_08c9f11e-2995-44a3-b165-8badf4d80777.089aa192c0d039b3f92e8712f0a89865.jpeg?odnHeight=580&odnWidth=580&odnBg=FFFFFF"
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
    "image_url": "https://static.vecteezy.com/system/resources/thumbnails/048/776/709/small/fresh-apple-juice-bottle-apple-cider-vinegar-apple-juice-healthy-apple-juice-transparent-background-png.png"
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
    "image_url": "https://m.media-amazon.com/images/I/819HJzGVugL.jpg"
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
    "image_url": "https://m.media-amazon.com/images/I/71wWKpuFjdL.jpg"
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
    "image_url": "https://tiimg.tistatic.com/fp/1/009/373/sharda-frozen-green-peas-953.jpg"
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
    "image_url": "https://www.kroger.com/product/images/large/front/0001111050729"
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
    "image_url": "https://image.migros.ch/d/mo-boxed/v-w-1000-h-1000/o-af-1-t.clr-fff/93521d9374e0a0bbc65eafd64e94bb0e2c4d2adb/zweifel-original-original-plain.jpg"
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
    "image_url": "https://m.media-amazon.com/images/I/81OcOmhUpbL.jpg"
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
    "image_url": "https://frankandsal.com/cdn/shop/products/oil1_1600x.png?v=1682096730"
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
    "image_url": "https://beeswiki.com/wp-content/uploads/2021/10/Orange-Blossom-Honey.png"
  }
]

example_products.each do |example_product|
  puts example_product[:name]
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
