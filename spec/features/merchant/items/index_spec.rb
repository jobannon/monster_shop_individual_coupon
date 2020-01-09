require 'rails_helper'

RSpec.describe 'when a merchant visits the order index page', type: :feature do
  before :each do
    @merchant = create :merchant
    @merchant_user = create :random_merchant_user, merchant:@merchant

    visit '/login'

    fill_in :email, with: @merchant_user.email
    fill_in :password, with: 'password'

    click_button 'Log In'
  end

  it 'can deactivate an item' do
    @active_items = create_list :item, 5, merchant: @merchant
    visit '/merchant/items'

    within "#item-#{@active_items[0].id}" do
      click_button 'Deactivate'
      expect(page).to have_button 'Activate'
    end
  end

  it 'can activate an item' do
    @inactive_items = create_list :item, 3, merchant: @merchant, active?: false
    visit '/merchant/items'

    within "#item-#{@inactive_items[0].id}" do
      click_button 'Activate'
      expect(page).to have_button 'Deactivate'

    end
  end
end
