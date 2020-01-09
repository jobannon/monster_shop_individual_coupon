# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
ItemOrder.destroy_all
User.destroy_all
Order.destroy_all
Merchant.destroy_all
Item.destroy_all
#merchants
# bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
# dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
merchants = FactoryBot.create_list(:merchant, 12)
items = Array.new
merchants.each do |merchant|
  items << FactoryBot.create_list(:item, 30, merchant: merchant)
end
items.flatten!
users = FactoryBot.create_list(:random_user, 100)

# create some orders
orders = FactoryBot.create_list(:order, 15)
orders.each do |order|
  order_items = items.sample(3)
  order_items.each do |item|
    ItemOrder.create(order_id: order.id, item_id: item.id, price: item.price, quantity: rand(item.inventory))
  end
end

# create some fufilled orders
orders = FactoryBot.create_list(:order, 15)
orders.each do |order|
  order_items = items.sample(3)
  order_items.each do |item|
    ItemOrder.create(order_id: order.id, item_id: item.id, price: item.price, quantity: rand(item.inventory), fulfilled_by_merchant: true)
  end
end

# create some packaged orders
orders = FactoryBot.create_list(:order, 15, status: 1)
orders.each do |order|
  order_items = items.sample(3)
  order_items.each do |item|
    ItemOrder.create(order_id: order.id, item_id: item.id, price: item.price, quantity: rand(item.inventory), fulfilled_by_merchant: true)
  end
end

admin = User.create(
  name: 'admin',
  email: 'admin@coffee.io',
  password: 'password',
  address: '420 Coffee St',
  city: 'Coffeetown',
  state: 'CO',
  zip: '80000',
  role: 1
)
merchant_test = FactoryBot.create(:merchant)
merchant= User.create(
  name: 'merchant',
  email: 'merchant@merchant.com',
  password: 'password',
  address: '420 Coffee St',
  city: 'Coffeetown',
  state: 'CO',
  zip: '80000',
  role: 2,
  merchant_id: merchants.first.id
)

regular_user= User.create(
  name: 'Regular User',
  email: 'regularuser@user.com',
  password: 'password',
  address: '420 Coffee St',
  city: 'Coffeetown',
  state: 'CO',
  zip: '80000',
  role: 0
)


#bike_shop items
# tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
#
# #dog_shop items
# pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
# dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
