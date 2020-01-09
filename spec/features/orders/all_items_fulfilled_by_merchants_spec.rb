require 'rails_helper'

RSpec.describe 'All merchants fulfill items on an order' do
  before :each do
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

    @user = create :random_reg_user_test
    @merchant_user_meg = create :random_merchant_user, merchant: @meg
    @merchant_user_mike = create :random_merchant_user, merchant: @mike
  end
  it 'and the order status changes from pending to packaged' do
    visit '/login'

    fill_in :email, with: @user.email
    fill_in :password, with: 'password'

    click_button 'Log In'

    visit "/items/#{@paper.id}"
    click_on "Add To Cart"
    visit "/items/#{@paper.id}"
    click_on "Add To Cart"
    visit "/items/#{@tire.id}"
    click_on "Add To Cart"
    visit "/items/#{@pencil.id}"
    click_on "Add To Cart"

    visit "/cart"
    click_on "Checkout"

    name = "Bert"
    address = "123 Sesame St."
    city = "NYC"
    state = "New York"
    zip = 10001

    fill_in :name, with: name
    fill_in :address, with: address
    fill_in :city, with: city
    fill_in :state, with: state
    fill_in :zip, with: zip

    click_button "Create Order"

    new_order = Order.last
    expect(new_order.status).to eq('Pending')

    click_link "Log Out"

    # login as Meg and fulfill item ordered from her
    visit '/login'
    fill_in :email, with: @merchant_user_meg.email
    fill_in :password, with: 'password'
    click_button "Log In"

    visit "/merchant/orders/#{new_order.id}"

    item_orders_meg = new_order.item_orders
                                .joins(:item)
                                .where('items.merchant_id = ?', @merchant_user_meg.merchant_id)

    item_orders_meg.each do |item_order|
      within "#item-order-#{item_order.id}" do
        click_button 'Fulfill'
      end
    end

    expect(new_order.status).to eq('Pending')

    click_link "Log Out"

    # login as Mike and fulfill items ordered from him
    visit '/login'
    fill_in :email, with: @merchant_user_mike.email
    fill_in :password, with: 'password'
    click_button "Log In"

    visit "/merchant/orders/#{new_order.id}"

    item_orders_mike = new_order.item_orders
                                .joins(:item)
                                .where('items.merchant_id = ?', @merchant_user_mike.merchant_id)

    item_orders_mike.each do |item_order|
      within "#item-order-#{item_order.id}" do
        click_button 'Fulfill'
      end
    end

    new_order_updated = Order.last

    expect(new_order_updated.status).to eq('Packaged')
  end
end
