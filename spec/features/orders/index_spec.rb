require 'rails_helper'

RSpec.describe 'as a user when i visit my orders page', type: :feature do
  before :each do
    @user = create :random_reg_user_test
    @orders = create_list(:order, 3, user: @user)

    visit '/login'

    fill_in :email, with: @user.email
    fill_in :password, with: 'password'

    click_button 'Log In'
    expect(current_path).to eq('/profile')
  end

  it 'will display all orders' do
    visit '/profile/orders'

    expect(page).to have_content(@orders[0].id)
    expect(page).to have_content(@orders[0].status)
    expect(page).to have_content(@orders[1].id)
    expect(page).to have_content(@orders[1].status)
    expect(page).to have_content(@orders[2].id)
    expect(page).to have_content(@orders[2].status)
  end

  it 'Displays 404 error when visitor attempts to view orders page' do

    click_on 'Log Out'

    visit '/profile/orders'
    expect(page).to have_content('404 Page Not Found')

    visit '/orders'
    expect(page).to have_content('404 Page Not Found')
  end
end
