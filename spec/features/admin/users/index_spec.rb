require 'rails_helper'

RSpec.describe 'User index page', type: :feature do
  describe 'As an admin user' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
      @dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
      @item = create :item, merchant: @bike_shop
      @user_regular = create :random_reg_user_test
      @user_merchant = create :random_merchant_user
      @user_admin = create :random_admin_user
    end

    it 'I cannot visit /admin/users as a non admin user' do
      visit "/"

      within '.navbar' do
        expect(page).to have_no_link('Users')
      end

      visit '/login'
      fill_in :email, with: @user_regular.email
      fill_in :password, with: 'password'

      click_button 'Log In'

      within '.navbar' do
        expect(page).to have_no_link('Users')
      end

      click_link 'Log Out'

      visit '/login'
      fill_in :email, with: @user_merchant.email
      fill_in :password, with: 'password'

      click_button 'Log In'

      within '.navbar' do
        expect(page).to have_no_link('Users')
      end
    end

    it "I can see users' details in the system at /admin/users" do
      visit '/login'

      fill_in :email, with: @user_admin.email
      fill_in :password, with: 'password'

      click_button 'Log In'
      within '.navbar' do
        click_link 'Users'
      end
      expect(current_path).to eq('/admin/users')

      within "#user-#{@user_regular.id}" do
        click_link "#{@user_regular.name}"
        expect(current_path).to eq("/admin/users/#{@user_regular.id}")
        visit "/admin/users"
        expect(page).to have_content(@user_regular.created_at)
        expect(page).to have_content(@user_regular.role)
      end

      within "#user-#{@user_regular.id}" do
        click_button "Deactivate"
      end
      expect(page).to have_content("User Deactivated")

      within "#user-#{@user_regular.id}" do
        click_button "Activate"
      end
      expect(page).to have_content("User Activated")

    end
  end
end
