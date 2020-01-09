require 'rails_helper'

RSpec.describe 'Merchant Order Show Page' do
  describe 'as an admin user when I visit an order show page for a merchant' do
    before :each do
      @admin = create :random_admin_user
      @user = create :random_reg_user_test
      @merchant = create :merchant
      @merchant_user = create :random_merchant_user, merchant:@merchant
      @item = create :item, merchant: @merchant, inventory: 10
      @order = create :order, user: @user
      ItemOrder.create(order_id: @order.id, item_id: @item.id, price: @item.price, quantity: 1)
    end

    it "I can fulfill individual items on the order on behalf of a merchant" do

      visit '/login'

      fill_in :email, with: @admin.email
      fill_in :password, with: 'password'

      click_button 'Log In'

      within ".navbar" do
        click_link "Merchants"
      end

      within "#merchant-#{@merchant.id}" do
        click_link "#{@merchant.name}"
      end

      within "#order-#{@order.id}" do
        click_link "#{@order.id}"
      end

      expect(current_path).to eq("/admin/merchant/#{@merchant.id}/orders/#{@order.id}")

      within "#item-#{@item.id}" do
        click_button "Fulfill"
        expect(page).to have_button("Unfulfill")
      end
    end
  end
end
