require 'rails_helper'

RSpec.describe 'when a user logs in', type: :feature do
  before :each do
    User.destroy_all
    @user = User.create(
      name: 'Granicus Higgins',
      email: 'lol@ex.com',
      address: '123 mail',
      city: 'Denver',
      state: 'CO',
      zip: '80123',
      password: 'pass123'
    )

    @user_2 = User.create(
      name: 'Gran Higgs',
      email: 'sjinisbae@ex.com',
      address: '123 mail',
      city: 'Denver',
      state: 'CO',
      zip: '80123',
      password: 'pass123',
      active?: false
    )

    @admin_user = User.create(
      name: 'Matt',
      email: 'werwer@sefsdfsdfsdfsdfsdf',
      address: '123 poop ln',
      city: 'Denver',
      state: 'CO',
      zip: '80000',
      password: 'pass123',
      role: 1
    )

    @merchant_user = User.create(
      name: 'Matt',
      email: 'wersdfsdfsdfawdqwevdhtjtyhgrfgeer@sefsdfsdfsdfsdfsdf',
      address: '123 poop ln',
      city: 'Denver',
      state: 'CO',
      zip: '80000',
      password: 'pass123',
      role: 2
    )
     @merchant = create :merchant
     @merchant.users << @merchant_user
  end

  it 'will log in user and create new session' do
    visit '/login'

    fill_in :email, with: @user.email
    fill_in :password, with: 'pass123'

    click_button 'Log In'
    expect(current_path).to eq('/profile')
    expect(page).to have_content("Welcome, #{@user.name}")
  end

  it 'will fail to log in if password is incorrect' do
    visit '/login'

    fill_in :email, with: @user.email
    fill_in :password, with: 'sdfssdc23'

    click_button 'Log In'
    expect(current_path).to eq('/login')
    expect(page).to have_content('Credentials were incorrect')
  end

  it 'will log in merchant user' do
    visit '/login'

    fill_in :email, with: @merchant_user.email
    fill_in :password, with: 'pass123'

    click_button 'Log In'

    expect(current_path).to eq('/merchant/dashboard')
  end

  it 'will log in admin user' do
    visit '/login'

    fill_in :email, with: @admin_user.email
    fill_in :password, with: 'pass123'

    click_button 'Log In'

    expect(current_path).to eq('/admin/dashboard')
  end

  it 'will not log in if user is logged in' do
    visit '/login'

    fill_in :email, with: @user.email
    fill_in :password, with: 'pass123'

    click_button 'Log In'
    expect(current_path).to eq('/profile')
    expect(page).to have_content("Welcome, #{@user.name}")

    visit '/login'

    expect(current_path).to eq('/profile')
  end

  it 'will fail to log in if user account is disabled' do
    visit '/login'

    fill_in :email, with: @user_2.email
    fill_in :password, with: 'pass123'

    click_button 'Log In'
    expect(current_path).to eq('/login')
    expect(page).to have_content('Account is Disabled')
  end
end
