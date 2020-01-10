require 'rails_helper'

RSpec.describe 'when an admin visits the admin dashboard', type: :feature do
  before :each do
    @admin = create :random_admin_user
    @user = create :random_reg_user_test

    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: @user.id, status: 1)
    @item_order_1 = @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

    visit '/login'

    fill_in :email, with: @admin.email
    fill_in :password, with: 'password'

    click_button 'Log In'
  end

  it 'has the ability to ship a packaged order' do

    expect(current_path).to eq('/admin/dashboard')

    within "#order-#{@order_1.id}" do
      click_on 'Ship Order'
    end

    expect(page).to have_content('Order has been shipped')
    within "#order-#{@order_1.id}" do
      expect(page).to have_content('Shipped')
    end
  end

  it 'redirects to order show when click on order id' do
    within "#order-#{@order_1.id}" do
      click_link "#{@order_1.id}"
    end

    expect(current_path).to eq("/admin/users/#{@user.id}/orders/#{@order_1.id}")
  end
end
