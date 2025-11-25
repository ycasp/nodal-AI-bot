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
puts "All products deleted: Procduct count = #{Product.count}"

fruits_img = URI.parse("https://media.istockphoto.com/id/529664572/photo/fruit-background.jpg?s=612x612&w=0&k=20&c=K7V0rVCGj8tvluXDqxJgu0AdMKF8axP0A15P-8Ksh3I=").open
veg_img = URI.parse("https://media.istockphoto.com/id/1203599923/photo/food-background-with-assortment-of-fresh-organic-vegetables.jpg?s=612x612&w=0&k=20&c=DZy1JMfUBkllwiq1Fm_LXtxA4DMDnExuF40jD8u9Z0Q=").open
dairy_img = URI.parse("https://images.unsplash.com/photo-1550630997-aea8d3d982ed?q=80&w=1528&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D").open
bake_img = URI.parse("https://plus.unsplash.com/premium_photo-1675788938970-e2716f23b1f9?q=80&w=1287&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D").open
meat_img = URI.parse("https://images.unsplash.com/photo-1603048297172-c92544798d5a?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D").open
sea_img = URI.parse("https://images.unsplash.com/photo-1642741580389-87dd75d913f4?q=80&w=3072&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D").open
freeze_img = URI.parse("https://images.unsplash.com/photo-1651383140368-9b3ee59c2981?q=80&w=1337&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D").open
pantry_img = URI.parse("https://images.unsplash.com/photo-1651383140368-9b3ee59c2981?q=80&w=1337&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D").open
bev_img = URI.parse("https://images.unsplash.com/photo-1613590759544-48ad7834d05f?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D").open
snacks_img = URI.parse("https://images.unsplash.com/photo-1614735241165-6756e1df61ab?q=80&w=3732&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D").open
CATEGORIES = {
  "Fruit"      => { price_kg: 2.0..6.0,    shelf: 4..21, img: fruits_img },
  "Vegetable"  => { price_kg: 1.5..5.0,    shelf: 5..21, img: veg_img },
  "Dairy"      => { price_kg: 1.2..6.0,    shelf: 7..21, img: dairy_img },
  "Bakery"     => { price_kg: 3.0..8.0,    shelf: 2..5, img: bake_img },
  "Meat"       => { price_kg: 8.0..20.0,   shelf: 2..5, img: meat_img },
  "Seafood"    => { price_kg: 10.0..30.0,  shelf: 2..4, img: sea_img },
  "Frozen"     => { price_kg: 2.0..6.0,    shelf: 180..730, img: freeze_img },
  "Pantry"     => { price_kg: 1.0..10.0,   shelf: 180..730, img: pantry_img },
  "Beverage"   => { price_kg: 0.5..4.0,    shelf: 30..365, img: bev_img },
  "Snacks"     => { price_kg: 5.0..20.0,   shelf: 90..365, img: snacks_img },
}

COUNTRIES = %w[
  Switzerland Germany France Italy Spain
  Netherlands Belgium Austria Poland Greece
  USA Canada Mexico Brazil India China
]

BASE_PRODUCTS = [
  ["Bananas",             "Fruit"],
  ["Gala Apples",         "Fruit"],
  ["Carrots",             "Vegetable"],
  ["Broccoli",            "Vegetable"],
  ["Whole Milk 1L",       "Dairy"],
  ["Natural Yogurt 500g", "Dairy"],
  ["White Bread Loaf",    "Bakery"],
  ["Wholegrain Bread",    "Bakery"],
  ["Chicken Breast",      "Meat"],
  ["Ground Beef 500g",    "Meat"],
  ["Salmon Fillet",       "Seafood"],
  ["Frozen Peas 1kg",     "Frozen"],
  ["Spaghetti 500g",      "Pantry"],
  ["Basmati Rice 1kg",    "Pantry"],
  ["Olive Oil 750ml",     "Pantry"],
  ["Tomato Passata 700g", "Pantry"],
  ["Cola Drink 1.5L",     "Beverage"],
  ["Orange Juice 1L",     "Beverage"],
  ["Potato Chips Paprika 200g", "Snacks"],
  ["Dark Chocolate 70% 100g",   "Snacks"]
]

def random_description(name, category)
  base = case category
         when "Fruit"      then "Fresh #{name.downcase}, ideal as a snack or for desserts."
         when "Vegetable"  then "Fresh #{name.downcase}, suitable for salads or cooking."
         when "Dairy"      then "Chilled dairy product, keep refrigerated."
         when "Bakery"     then "Freshly baked, best consumed within a few days."
         when "Meat"       then "Chilled meat product, cook thoroughly before consumption."
         when "Seafood"    then "Fresh seafood, keep refrigerated and consume quickly."
         when "Frozen"     then "Frozen product, store at -18°C."
         when "Pantry"     then "Shelf‑stable pantry staple for everyday cooking."
         when "Beverage"   then "Ready‑to‑drink beverage, serve chilled."
         when "Snacks"     then "Ready‑to‑eat snack for any occasion."
         else "Grocery product."
         end
  "#{name}. #{base}"
end

def random_minimum_qty(category)
  case category
  when "Fruit", "Vegetable", "Meat", "Seafood", "Frozen", "Pantry", "Snacks"
    [0.25, 0.3, 0.5, 1.0].sample
  when "Dairy", "Bakery", "Beverage"
    [0.5, 1.0, 1.5].sample
  else
    1.0
  end
end

def random_price_unit(price_kg, minimum_qty)
  # price per unit ≈ price per kg * qty, plus small random factor
  (price_kg * minimum_qty * rand(0.9..1.3)).round(2)
end

def random_price_kg(range)
  (rand(range)).round(2)
end

def random_days_until_expire(range)
  rand(range)
end

10.times do |i|
  base_name, category = BASE_PRODUCTS.sample
  config = CATEGORIES[category]

  price_kg = random_price_kg(config[:price_kg])
  min_qty  = random_minimum_qty(category)
  price_unit = random_price_unit(price_kg, min_qty)
  days      = random_days_until_expire(config[:shelf])
  country   = COUNTRIES.sample

  variant_suffix =
    case category
    when "Fruit", "Vegetable"
      %w[Class\ I Organic Conventional].sample
    when "Meat", "Seafood"
      %w[Standard Premium Family\ Pack].sample
    when "Bakery"
      %w[Sliced Rustic Small Large].sample
    else
      %w[Classic Original Family\ Pack Value\ Pack None].sample
    end

  name =
    if variant_suffix == "None"
      base_name
    else
      "#{base_name} #{variant_suffix}"
    end

  attrs = {
    name:               name,
    description:        random_description(base_name, category),
    category:           category,
    minimum_qty:        min_qty,
    price_unit:         price_unit,
    price_kg:           price_kg,
    country_of_origin:  country,
    days_until_expired: days
  }

  # For seeding:
  prod = Product.new(attrs)
  prod.photo.attach(io: config[:img], filename: "#{category}.jpg", content_type: "image/png")
  prod.save!
  # Or, if you just want to inspect:
  # puts attrs.inspect
  puts "created a product"
end
puts "created #{Product.count} number of products, e.g. #{Product.first.name}"
