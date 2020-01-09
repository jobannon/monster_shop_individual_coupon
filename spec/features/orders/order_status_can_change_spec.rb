require 'rails_helper'

RSpec.describe 'When a merchant fulfills an order it changes order status from pending to packaged' do
  before :each do
    @admin = create :random_admin_user
    @user = create :random_reg_user_test
    @merchant = create :merchant
    @merchant_user = create :random_merchant_user, merchant:@merchant
    @item = create :item, merchant: @merchant, inventory: 10
    @order = create :order, user: @user
    @item_order_1 = ItemOrder.create(order_id: @order.id, item_id: @item.id, price: @item.price, quantity: 1)
  end

  it 'shows a changed status from pending to packaged when an order has been fulfilled by a merchant' do
    visit '/login'

    fill_in :email, with: @merchant_user.email
    fill_in :password, with: 'password'

    click_button 'Log In'

    within "#merchant_dashboard_orders" do
      click_link "#{@order.id}"
    end

    within "#item-order-#{@item_order_1.id}" do
      click_button 'Fulfill'
      expect(page).to have_button('Unfulfill')
    end

    visit '/merchant/dashboard'

    within "#order-#{@order.id}" do
      expect(page).to have_content("Packaged")
    end
  end
end
