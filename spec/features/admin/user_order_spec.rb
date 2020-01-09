require 'rails_helper'

RSpec.describe 'as an admin when i visit a user profile', type: :feature do
  before :each do
    @admin = create :random_admin_user
    @user = create :random_reg_user_test
    @merchant = create :merchant
    @item = create :item, merchant: @merchant
    @order = create :order, user: @user
    ItemOrder.create(order_id: @order.id, item_id: @item.id, price: @item.price, quantity: 1)
  end

  it 'can view user profile as admin' do
    visit '/login'

    fill_in :email, with: @admin.email
    fill_in :password, with: 'password'

    click_button 'Log In'

    visit "/admin/users/#{@user.id}"
    expect(page).to have_link("Update #{@user.name}'s password")
    expect(page).to have_link("#{@user.name}'s Orders")
  end

  it 'cannot view admin user profile page as user' do
    visit '/login'

    fill_in :email, with: @user.email
    fill_in :password, with: 'password'

    click_button 'Log In'

    visit "/admin/users/#{@user.id}"
    expect(page).to have_content('404 Page Not Found')
  end

  it 'can view order show page as admin' do
    visit '/login'

    fill_in :email, with: @admin.email
    fill_in :password, with: 'password'

    click_button 'Log In'
    visit "/admin/users/#{@user.id}"

    click_on "#{@user.name}'s Orders"

    expect(current_path).to eq("/admin/users/#{@user.id}/orders")
    expect(page).to have_content(@user.name)
    expect(page).to have_content("Order ##{@order.id}")
  end

  it 'can change order status on order show as admin' do
    @order.update!(status: 1)
    visit '/login'

    fill_in :email, with: @admin.email
    fill_in :password, with: 'password'

    click_button 'Log In'
    visit "/admin/users/#{@user.id}/orders/#{@order.id}"

    expect(page).to have_button('Ship Order')

    click_button 'Ship Order'
    expect(current_path).to eq('/admin/dashboard')
  end

  it 'can delete an order for a user' do
    @order.update!(status: 1)
    visit '/login'

    fill_in :email, with: @admin.email
    fill_in :password, with: 'password'

    click_button 'Log In'

    visit "/admin/users/#{@user.id}/orders/#{@order.id}"

    click_button 'Cancel Order'
    expect(page).to have_content("User order has been cancelled")
  end

end
