# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Product.destroy_all
puts "All products deleted: Procduct count = #{Product.count}"

CATEGORIES = {
  "Fruit"      => { price_kg: 2.0..6.0,    shelf: 4..21 },
  "Vegetable"  => { price_kg: 1.5..5.0,    shelf: 5..21 },
  "Dairy"      => { price_kg: 1.2..6.0,    shelf: 7..21 },
  "Bakery"     => { price_kg: 3.0..8.0,    shelf: 2..5  },
  "Meat"       => { price_kg: 8.0..20.0,   shelf: 2..5  },
  "Seafood"    => { price_kg: 10.0..30.0,  shelf: 2..4  },
  "Frozen"     => { price_kg: 2.0..6.0,    shelf: 180..730 },
  "Pantry"     => { price_kg: 1.0..10.0,   shelf: 180..730 },
  "Beverage"   => { price_kg: 0.5..4.0,    shelf: 30..365 },
  "Snacks"     => { price_kg: 5.0..20.0,   shelf: 90..365 }
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

100.times do |i|
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
  Product.create!(attrs)

  # Or, if you just want to inspect:
  # puts attrs.inspect
end
puts "created #{Product.count} number of products, e.g. #{Product.first.name}"
