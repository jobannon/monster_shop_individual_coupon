require 'rails_helper'

RSpec.describe 'as a admin' do
  before :each do
    @merchant = create :merchant
    @merchant_user = create :random_merchant_user, merchant: @merchant
    @items = create_list :item, 5, merchant: @merchant
    @coffee = @merchant.items.create(name: "coffee", description: "i hate my job", price: 5000, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)


    @admin = create :random_admin_user

    visit 'login'

    fill_in :email, with: @admin.email
    fill_in :password, with: 'password'

    click_button 'Log In'
  end

  it 'allows me to edit an item information' do
    visit "/items/#{@coffee.id}"

    click_link 'Edit Item'

    expect(current_path).to eq("/items/#{@coffee.id}/edit")

    fill_in 'Name', with: "Cup O' Jo"
    fill_in 'Price', with: 4.00
    fill_in 'Description', with: "Hot coffee. Real hot."
    fill_in 'Image', with: ""
    fill_in 'Inventory', with: 11

    click_button "Update Item"

    expect(page).to have_content("Item Updated")
    expect(page).to have_content("Cup O' Jo")
    expect(page).to have_content("$4.00")
    expect(page).to have_content("Hot coffee. Real hot.")
    expect(page).to have_content("Inventory: 11")
  end
end
