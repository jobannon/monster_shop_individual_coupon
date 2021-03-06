require 'rails_helper'

RSpec.describe 'As a regular user', type: :feature do
  before :each do
    @user = create :random_reg_user_test

    visit '/login'

    fill_in :email, with: @user.email
    fill_in :password, with: 'password'

    click_button 'Log In'
  end

  it 'will prevent me from visiting /admin' do
    visit '/admin'
    expect(page).to have_content('404 Page Not Found')

    visit '/admin/dashboard'
    expect(page).to have_content('404 Page Not Found')
  end

  it 'will prevent me from visiting /merchant' do
    visit '/merchant'
    expect(page).to have_content('404 Page Not Found')

    visit '/merchant/dashboard'
    expect(page).to have_content('404 Page Not Found')
  end
end
