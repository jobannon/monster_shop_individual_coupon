require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'relationships' do
    it {should have_many :orders}
    it {should belong_to :merchant}
  end

  describe 'roles' do
    before :each do
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

      @user = User.create(
        name: 'Jim',
        email: 'wsdfsdffsdfsdfsdf',
        address: '1222 poop ln',
        city: 'Denver',
        state: 'CO',
        zip: '80001',
        password: 'pass153',
      )
    end

    it 'can be created as an admin' do
      expect(@admin_user.role).to eq('admin')
      expect(@admin_user.admin?).to be_truthy
    end

    it 'can be created as default user' do
      expect(@user.role).to eq('default')
      expect(@user.default?).to be_truthy
    end

    it 'can be created as merchant user' do
      expect(@merchant_user.role).to eq('merchant')
      expect(@merchant_user.merchant?).to be_truthy
    end
  end
end
