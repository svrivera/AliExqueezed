# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Spree::Core::Engine.load_seed if defined?(Spree::Core)
# Spree::Auth::Engine.load_seed if defined?(Spree::Auth)

require 'consultas'

chile = Spree::Country.create(
	iso_name: "CL",
	name: "Chile")

rm = Spree::State.create(
	name: "Región Metropolitana",
	abbr: "RM",
	country_id: 1)

providencia =  Spree::Zone.create(
	name: "Providencia",
	state_ids: ["", 1])

shipping_category = Spree::ShippingCategory.find_or_create_by!(name: 'Default')
shipping_methods = [
  {
    name: "Free Shipping",
    zones: [providencia],
    display_on: 'both',
    shipping_categories: [shipping_category]
  }
]

shipping_methods.each do |attributes|
  Spree::ShippingMethod.where(name: attributes[:name]).first_or_create! do |shipping_method|
    shipping_method.calculator = Spree::Calculator::Shipping::FlatRate.create!
    shipping_method.zones = attributes[:zones]
    shipping_method.display_on = attributes[:display_on]
    shipping_method.shipping_categories = attributes[:shipping_categories]
  end
end

{
  "Free Shipping" => [0, "CLP"]
}.each do |shipping_method_name, (price, currency)|
  shipping_method = Spree::ShippingMethod.find_by!(name: shipping_method_name)
  shipping_method.calculator.preferences = {
    amount: price,
    currency: currency
  }
  shipping_method.calculator.save!
  shipping_method.save!
end


Spree::Gateway::Bogus.where(
  name: "Credit Card",
  description: "Bogus payment gateway.",
  active: true
).first_or_create!

Spree::PaymentMethod::Check.where(
  name: "Check",
  description: "Pay by check.",
  active: true
).first_or_create!


l = []
get_almacenes().parsed_response.each do |alm|
	l.push(alm['_id'])
end
locations =[]
for k in (0..4)
	locations.push(Spree::StockLocation.where(name: l[k]).first_or_create!)
end

fruta = Spree::TaxCategory.where(name: "Fruta").first_or_create!
jugos = Spree::TaxCategory.where(name: "Jugos").first_or_create!
default_shipping_category = Spree::ShippingCategory.where(name: "Default").first_or_create!
products = [
{
name: "Manzana",
tax_category: fruta,
price: 2355,
description: "Este jugo contiene: ",
sku: 20
},
{
name: "Naranja",
tax_category: fruta,
price: 3055,
description: "Este jugo contiene: ",
sku: 30
},
{
name: "Frutilla",
tax_category: fruta,
price: 2366,
description: "Este jugo contiene: ",
sku: 40
},
{
name: "Frambuesa",
tax_category: fruta,
price: 2524,
description: "Este jugo contiene: ",
sku: 50
},
{
name: "Durazno",
tax_category: fruta,
price: 2162,
description: "Este jugo contiene: ",
sku: 60
},
{
name: "Arandano",
tax_category: fruta,
price: 2329,
description: "Este jugo contiene: ",
sku: 70
},
{
name: "Jugo Manzana",
tax_category: jugos,
price: 3458,
description: "Este jugo contiene: 'Manzana'",
sku: 200000000
},
{
name: "Jugo Manzana-Naranja",
tax_category: jugos,
price: 3135,
description: "Este jugo contiene: 'Manzana', 'Naranja'",
sku: 230000000
},
{
name: "Jugo Manzana-Naranja-Frutilla",
tax_category: jugos,
price: 3195,
description: "Este jugo contiene: 'Manzana', 'Naranja', 'Frutilla'",
sku: 234000000
},
{
name: "Jugo Manzana-Naranja-Frutilla-Frambuesa",
tax_category: jugos,
price: 3848,
description: "Este jugo contiene: 'Manzana', 'Naranja', 'Frutilla', 'Frambuesa'",
sku: 234500000
},
{
name: "Jugo Manzana-Naranja-Frutilla-Frambuesa-Durazno",
tax_category: jugos,
price: 2757,
description: "Este jugo contiene: 'Manzana', 'Naranja', 'Frutilla', 'Frambuesa', 'Durazno'",
sku: 234560000
},
{
name: "Jugo Fruit Super Punch",
tax_category: jugos,
price: 2685,
description: "Este jugo contiene: 'Manzana', 'Naranja', 'Frutilla', 'Frambuesa', 'Durazno'",
sku: 234567000
},
{
name: "Jugo Manzana-Naranja-Frutilla-Frambuesa-Arandano",
tax_category: jugos,
price: 2922,
description: "Este jugo contiene: 'Manzana', 'Naranja', 'Frutilla', 'Frambuesa', 'Arandano'",
sku: 234570000
},
{
name: "Jugo Manzana-Naranja-Frutilla-Durazno",
tax_category: jugos,
price: 2644,
description: "Este jugo contiene: 'Manzana', 'Naranja', 'Frutilla', 'Durazno'",
sku: 234600000
},
{
name: "Jugo Manzana-Naranja-Frutilla-Durazno-Arandano",
tax_category: jugos,
price: 2138,
description: "Este jugo contiene: 'Manzana', 'Naranja', 'Frutilla', 'Durazno', 'Arandano'",
sku: 234670000
},
{
name: "Jugo Manzana-Naranja-Frutilla-Arandano",
tax_category: jugos,
price: 3314,
description: "Este jugo contiene: 'Manzana', 'Naranja', 'Frutilla', 'Arandano'",
sku: 234700000
},
{
name: "Jugo Manzana-Naranja-Frambuesa",
tax_category: jugos,
price: 3856,
description: "Este jugo contiene: 'Manzana', 'Naranja', 'Frambuesa'",
sku: 235000000
},
{
name: "Jugo Manzana-Naranja-Frambuesa-Durazno",
tax_category: jugos,
price: 3183,
description: "Este jugo contiene: 'Manzana', 'Naranja', 'Frambuesa', 'Durazno'",
sku: 235600000
},
{
name: "Jugo Manzana-Naranja-Frambuesa-Durazno-Arandano",
tax_category: jugos,
price: 3088,
description: "Este jugo contiene: 'Manzana', 'Naranja', 'Frambuesa', 'Durazno', 'Arandano'",
sku: 235670000
},
{
name: "Jugo Manzana-Naranja-Frambuesa-Arandano",
tax_category: jugos,
price: 2963,
description: "Este jugo contiene: 'Manzana', 'Naranja', 'Frambuesa', 'Arandano'",
sku: 235700000
},
{
name: "Jugo Manzana-Naranja-Durazno",
tax_category: jugos,
price: 3300,
description: "Este jugo contiene: 'Manzana', 'Naranja', 'Durazno'",
sku: 236000000
},
{
name: "Jugo Manzana-Naranja-Durazno-Arandano",
tax_category: jugos,
price: 2483,
description: "Este jugo contiene: 'Manzana', 'Naranja', 'Durazno', 'Arandano'",
sku: 236700000
},
{
name: "Jugo Manzana-Naranja-Arandano",
tax_category: jugos,
price: 2169,
description: "Este jugo contiene: 'Manzana', 'Naranja', 'Arandano'",
sku: 237000000
},
{
name: "Jugo Manzana-Frutilla",
tax_category: jugos,
price: 3114,
description: "Este jugo contiene: 'Manzana', 'Frutilla'",
sku: 240000000
},
{
name: "Jugo Manzana-Frutilla-Frambuesa",
tax_category: jugos,
price: 3712,
description: "Este jugo contiene: 'Manzana', 'Frutilla', 'Frambuesa'",
sku: 245000000
},
{
name: "Jugo Manzana-Frutilla-Frambuesa-Durazno",
tax_category: jugos,
price: 3103,
description: "Este jugo contiene: 'Manzana', 'Frutilla', 'Frambuesa', 'Durazno'",
sku: 245600000
},
{
name: "Jugo Manzana-Frutilla-Frambuesa-Durazno-Arandano",
tax_category: jugos,
price: 2747,
description: "Este jugo contiene: 'Manzana', 'Frutilla', 'Frambuesa', 'Durazno', 'Arandano'",
sku: 245670000
},
{
name: "Jugo Manzana-Frutilla-Frambuesa-Arandano",
tax_category: jugos,
price: 3818,
description: "Este jugo contiene: 'Manzana', 'Frutilla', 'Frambuesa', 'Arandano'",
sku: 245700000
},
{
name: "Jugo Manzana-Frutilla-Durazno",
tax_category: jugos,
price: 2895,
description: "Este jugo contiene: 'Manzana', 'Frutilla', 'Durazno'",
sku: 246000000
},
{
name: "Jugo Manzana-Frutilla-Durazno-Arandano",
tax_category: jugos,
price: 2644,
description: "Este jugo contiene: 'Manzana', 'Frutilla', 'Durazno', 'Arandano'",
sku: 246700000
},
{
name: "Jugo Manzana-Frutilla-Arandano",
tax_category: jugos,
price: 2766,
description: "Este jugo contiene: 'Manzana', 'Frutilla', 'Arandano'",
sku: 247000000
},
{
name: "Jugo Manzana-Frambuesa",
tax_category: jugos,
price: 2641,
description: "Este jugo contiene: 'Manzana', 'Frambuesa'",
sku: 250000000
},
{
name: "Jugo Manzana-Frambuesa-Durazno",
tax_category: jugos,
price: 3478,
description: "Este jugo contiene: 'Manzana', 'Frambuesa', 'Durazno'",
sku: 256000000
},
{
name: "Jugo Manzana-Frambuesa-Durazno-Arandano",
tax_category: jugos,
price: 3441,
description: "Este jugo contiene: 'Manzana', 'Frambuesa', 'Durazno', 'Arandano'",
sku: 256700000
},
{
name: "Jugo Manzana-Frambuesa-Arandano",
tax_category: jugos,
price: 3598,
description: "Este jugo contiene: 'Manzana', 'Frambuesa', 'Arandano'",
sku: 257000000
},
{
name: "Jugo Manzana-Durazno",
tax_category: jugos,
price: 2673,
description: "Este jugo contiene: 'Manzana', 'Durazno'",
sku: 260000000
},
{
name: "Jugo Manzana-Durazno-Arandano",
tax_category: jugos,
price: 3990,
description: "Este jugo contiene: 'Manzana', 'Durazno', 'Arandano'",
sku: 267000000
},
{
name: "Jugo Manzana-Arandano",
tax_category: jugos,
price: 2340,
description: "Este jugo contiene: 'Manzana', 'Arandano'",
sku: 270000000
},
{
name: "Jugo Vitamina Naranja",
tax_category: jugos,
price: 3495,
description: "Este jugo contiene: 'Naranja'",
sku: 300000000
},
{
name: "Jugo Naranja-Frutilla",
tax_category: jugos,
price: 2927,
description: "Este jugo contiene: 'Naranja', 'Frutilla'",
sku: 340000000
},
{
name: "Jugo Naranja-Frutilla-Frambuesa",
tax_category: jugos,
price: 2372,
description: "Este jugo contiene: 'Naranja', 'Frutilla', 'Frambuesa'",
sku: 345000000
},
{
name: "Jugo Naranja-Frutilla-Frambuesa-Durazno",
tax_category: jugos,
price: 3610,
description: "Este jugo contiene: 'Naranja', 'Frutilla', 'Frambuesa', 'Durazno'",
sku: 345600000
},
{
name: "Jugo Naranja-Frutilla-Frambuesa-Durazno-Arandano",
tax_category: jugos,
price: 2424,
description: "Este jugo contiene: 'Naranja', 'Frutilla', 'Frambuesa', 'Durazno', 'Arandano'",
sku: 345670000
},
{
name: "Jugo Mix Tropical",
tax_category: jugos,
price: 3331,
description: "Este jugo contiene: 'Naranja', 'Frutilla', 'Frambuesa', 'Arandano'",
sku: 345700000
},
{
name: "Jugo Naranja-Frutilla-Durazno",
tax_category: jugos,
price: 2552,
description: "Este jugo contiene: 'Naranja', 'Frutilla', 'Durazno'",
sku: 346000000
},
{
name: "Jugo Naranja-Frutilla-Durazno-Arandano",
tax_category: jugos,
price: 2549,
description: "Este jugo contiene: 'Naranja', 'Frutilla', 'Durazno', 'Arandano'",
sku: 346700000
},
{
name: "Jugo Naranja-Frutilla-Arandano",
tax_category: jugos,
price: 3916,
description: "Este jugo contiene: 'Naranja', 'Frutilla', 'Arandano'",
sku: 347000000
},
{
name: "Jugo Naranja-Frambuesa",
tax_category: jugos,
price: 3603,
description: "Este jugo contiene: 'Naranja', 'Frambuesa'",
sku: 350000000
},
{
name: "Jugo Naranja-Frambuesa-Durazno",
tax_category: jugos,
price: 2157,
description: "Este jugo contiene: 'Naranja', 'Frambuesa', 'Durazno'",
sku: 356000000
},
{
name: "Jugo Naranja-Frambuesa-Durazno-Arandano",
tax_category: jugos,
price: 2285,
description: "Este jugo contiene: 'Naranja', 'Frambuesa', 'Durazno', 'Arandano'",
sku: 356700000
},
{
name: "Jugo Naranja-Frambuesa-Arandano",
tax_category: jugos,
price: 3018,
description: "Este jugo contiene: 'Naranja', 'Frambuesa', 'Arandano'",
sku: 357000000
},
{
name: "Jugo Naranja-Durazno",
tax_category: jugos,
price: 3102,
description: "Este jugo contiene: 'Naranja', 'Durazno'",
sku: 360000000
},
{
name: "Jugo Naranja-Durazno-Arandano",
tax_category: jugos,
price: 3632,
description: "Este jugo contiene: 'Naranja', 'Durazno', 'Arandano'",
sku: 367000000
},
{
name: "Jugo Naranja-Arandano",
tax_category: jugos,
price: 2118,
description: "Este jugo contiene: 'Naranja', 'Arandano'",
sku: 370000000
},
{
name: "Jugo Frutilla",
tax_category: jugos,
price: 3622,
description: "Este jugo contiene: 'Frutilla'",
sku: 400000000
},
{
name: "Jugo Frutilla-Frambuesa",
tax_category: jugos,
price: 2962,
description: "Este jugo contiene: 'Frutilla', 'Frambuesa'",
sku: 450000000
},
{
name: "Jugo Frutilla-Frambuesa-Durazno",
tax_category: jugos,
price: 2805,
description: "Este jugo contiene: 'Frutilla', 'Frambuesa', 'Durazno'",
sku: 456000000
},
{
name: "Jugo Frutilla-Frambuesa-Durazno-Arandano",
tax_category: jugos,
price: 2364,
description: "Este jugo contiene: 'Frutilla', 'Frambuesa', 'Durazno', 'Arandano'",
sku: 456700000
},
{
name: "Jugo Berries",
tax_category: jugos,
price: 2556,
description: "Este jugo contiene: 'Frutilla', 'Frambuesa', 'Arandano'",
sku: 457000000
},
{
name: "Jugo Frutilla-Durazno",
tax_category: jugos,
price: 3630,
description: "Este jugo contiene: 'Frutilla', 'Durazno'",
sku: 460000000
},
{
name: "Jugo Frutilla-Durazno-Arandano",
tax_category: jugos,
price: 2141,
description: "Este jugo contiene: 'Frutilla', 'Durazno', 'Arandano'",
sku: 467000000
},
{
name: "Jugo Frutilla-Arandano",
tax_category: jugos,
price: 2440,
description: "Este jugo contiene: 'Frutilla', 'Arandano'",
sku: 470000000
},
{
name: "Jugo Frambuesa",
tax_category: jugos,
price: 3566,
description: "Este jugo contiene: 'Frambuesa'",
sku: 500000000
},
{
name: "Jugo Frambuesa-Durazno",
tax_category: jugos,
price: 2732,
description: "Este jugo contiene: 'Frambuesa', 'Durazno'",
sku: 560000000
},
{
name: "Jugo Frambuesa-Durazno-Arandano",
tax_category: jugos,
price: 2959,
description: "Este jugo contiene: 'Frambuesa', 'Durazno', 'Arandano'",
sku: 567000000
},
{
name: "Jugo Frambuesa-Arandano",
tax_category: jugos,
price: 2342,
description: "Este jugo contiene: 'Frambuesa', 'Arandano'",
sku: 570000000
},
{
name: "Jugo Durazno",
tax_category: jugos,
price: 2880,
description: "Este jugo contiene: 'Durazno'",
sku: 600000000
},
{
name: "Jugo Durazno-Arandano",
tax_category: jugos,
price: 3998,
description: "Este jugo contiene: 'Durazno', 'Arandano'",
sku: 670000000
},
{
name: "Jugo Arandano",
tax_category: jugos,
price: 3350,
description: "Este jugo contiene: 'Arandano'",
sku: 700000000
}
]
products.each do | product_attrs |
	Spree::Config[:currency] = 'CLP'
	new_product = Spree::Product.where(name: product_attrs[:name], tax_category: product_attrs[:tax_category]).first_or_create! do | product |
		product.price = product_attrs[:price]
		product.description = product_attrs[:description]
		product.available_on = Time.zone.now
		product.sku = product_attrs[:sku]
		product.shipping_category = default_shipping_category
	end
end

locations.each do |location|
	get_stock(location.name).parsed_response.each do |item|
		variant = Spree::Variant.where(sku: item['_id']).first
		cantidad = item['total'].to_i
		stockitem = Spree::StockItem.where(stock_location_id: location.id, variant_id: variant.id).first

		movement = Spree::StockMovement.create(stock_item: stockitem, quantity: cantidad)
	end
end
