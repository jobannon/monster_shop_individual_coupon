require 'rails_helper'

RSpec.describe 'Admin can update user info and password' do
  before :each do
    @admin = create :random_admin_user
    @user = create :random_reg_user_test

    visit '/login'

    fill_in :email, with: @admin.email
    fill_in :password, with: 'password'

    click_button 'Log In'

    visit "/admin/users/#{@user.id}"
  end

  it 'can edit user info' do
    click_link 'Edit Profile'

    expect(current_path).to eq("/admin/users/#{@user.id}/edit")
    fill_in :email, with: 'email@superdood.org'

    click_button 'Save Changes'
    expect(current_path).to eq("/admin/users/#{@user.id}")
    expect(page).to have_content('email@superdood.org')
  end

  it 'can update user password' do
    click_link 'Update Password'

    expect(current_path).to eq("/admin/users/#{@user.id}/edit-pw")
    fill_in :password, with: 'newpassword'
    fill_in :password_confirmation, with: 'newpassword'
    click_on 'Update Password'

    expect(current_path).to eq("/admin/users/#{@user.id}")
    click_on 'Log Out'

    visit 'login'
    fill_in :email, with: @user.email
    fill_in :password, with: 'newpassword'

    click_button 'Log In'
    expect(current_path).to eq '/profile'
  end
end
