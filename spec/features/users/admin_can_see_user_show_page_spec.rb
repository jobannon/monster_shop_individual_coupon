require 'rails_helper'

RSpec.describe 'Admin can see user show page' do
  it 'when visiting its dashboard and details of each order' do
    mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

    user_default_1 = create :random_reg_user_test
    visit '/login'
    fill_in :email, with: user_default_1.email
    fill_in :password, with: 'password'
    click_button 'Log In'

    visit "/items/#{paper.id}"
    click_on "Add To Cart"
    visit "/items/#{paper.id}"
    click_on "Add To Cart"
    visit "/items/#{tire.id}"
    click_on "Add To Cart"
    visit "/items/#{pencil.id}"
    click_on "Add To Cart"

    visit "/cart"
    click_on "Checkout"

    fill_in :name, with: "Bert"
    fill_in :address, with: "123 Sesame St."
    fill_in :city, with: "NYC"
    fill_in :state, with: "New York"
    fill_in :zip, with: 10001

    click_button "Create Order"

    order_bert = Order.last

    click_link 'Log Out'

    user_admin = create :random_admin_user

    visit '/login'
    fill_in :email, with: user_admin.email
    fill_in :password, with: 'password'
    click_button 'Log In'
    expect(current_path).to eq("/admin/dashboard")

    within "#orders" do
      within "#order-#{order_bert.id}" do
         click_link user_default_1.name
      end
    end

    expect(current_path).to eq("/admin/users/#{user_default_1.id}")

    expect(page).to have_content(user_default_1.name)
    expect(page).to have_content(user_default_1.email)
    expect(page).to have_content(user_default_1.address)
    expect(page).to have_content(user_default_1.city)
    expect(page).to have_content(user_default_1.state)
    expect(page).to have_content(user_default_1.zip)

    expect(page).to have_link("Edit #{user_default_1.name}'s Profile")
    expect(page).to have_link("Update #{user_default_1.name}'s password")
    expect(page).to have_link("#{user_default_1.name}'s Orders")
  end
end
