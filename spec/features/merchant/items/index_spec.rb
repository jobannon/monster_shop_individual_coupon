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

  it 'shows all item information including item name, desc, image, price, and inventory' do
    @item_disp = create_list :item, 5, merchant: @merchant

    visit '/merchant/items'

    within "#item-#{@item_disp[0].id}" do
      expect(page).to have_content(@item_disp[0].name)
      expect(page).to have_content(@item_disp[0].description)
      expect(page).to have_content(@item_disp[0].price)
      expect(page).to have_content(@item_disp[0].inventory)
      expect(page).to have_css("img[src*='#{@item_disp[0].image}']")
    end
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

  it 'can delete an item' do
    @del_items = create_list :item, 5, merchant: @merchant

    visit '/merchant/items'

    within "#item-#{@del_items[0].id}" do
      expect(page).to have_content(@del_items[0].name)
      click_link 'Delete Item'
    end
    expect(page).to have_content("Item Deleted")
  end
end
