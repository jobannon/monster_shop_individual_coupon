require 'rails_helper'

RSpec.describe 'as a user when i visit an orders show page', type: :feature do
  before :each do
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

    @user = create :random_reg_user_test
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

    @order = Order.last
  end

  it 'will render the order show page' do
    visit "/profile/orders/#{@order.id}"

    within '.shipping-address' do
      expect(page).to have_content(@order.name)
      expect(page).to have_content(@order.address)
      expect(page).to have_content(@order.city)
      expect(page).to have_content(@order.state)
      expect(page).to have_content(@order.zip)
    end

    @order.item_orders.each do |item_order|
      within "#item-#{item_order.item_id}" do
        expect(page).to have_css("img[src*='#{item_order.item.image}']")
        expect(page).to have_link(item_order.item.name)
        expect(page).to have_link(item_order.item.merchant.name)
        expect(page).to have_content("$#{item_order.price}")
        expect(page).to have_content(item_order.quantity)
        expect(page).to have_content("$#{item_order.subtotal}")
      end
    end

    within "#order_ID" do 
      expect(page).to have_content(@order.id)
    end 
    within "#status" do
      expect(page).to have_content(@order.status)
    end

    within "#totalquantity" do
      expect(page).to have_content(@order.total_quantity)
    end

    within "#grandtotal" do
      expect(page).to have_content(@order.grandtotal)
    end

    within "#datecreated" do
      expect(page).to have_content(@order.created_at)
    end

    within "#datelastudpated" do
      expect(page).to have_content(@order.updated_at)
    end
  end

  it 'will 404 if not default user' do
    click_link 'Log Out'

    visit "/profile/orders/#{@order.id}"

    expect(page).to have_content('404 Page Not Found')
  end

  it 'will cancel order id i click on the cancel order button' do
    visit "/profile/orders/#{@order.id}"

    click_button 'Cancel Order'

    expect(@order.Cancelled?)
  end
end
