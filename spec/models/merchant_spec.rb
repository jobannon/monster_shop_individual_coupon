require 'rails_helper'

describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it {should have_many :items}
    it {should have_many :users}
    it {should have_many :orders}
  end

  describe 'instance methods' do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @merchant = create :merchant
      @merchants = create_list(:merchant, 10)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @user_1 = create :random_reg_user_test
    end
    it 'no_orders' do
      expect(@meg.no_orders?).to eq(true)

      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: @user_1.id)
      item_order_1 = order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.no_orders?).to eq(false)
    end

    it 'item_count' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 30, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)

      expect(@meg.item_count).to eq(2)
    end

    it 'average_item_price' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)

      expect(@meg.average_item_price).to eq(70)
    end

    it 'distinct_cities' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)
      user_1 = create :random_reg_user_test
      user_2 = create :random_reg_user_test
      user_3 = create :random_reg_user_test
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: user_1.id)
      order_2 = Order.create!(name: 'Brian', address: '123 Brian Ave', city: 'Denver', state: 'CO', zip: 17033, user_id: user_2.id)
      order_3 = Order.create!(name: 'Dao', address: '123 Mike Ave', city: 'Denver', state: 'CO', zip: 17033, user_id: user_3.id)
      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      order_2.item_orders.create!(item: chain, price: chain.price, quantity: 2)
      order_3.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.distinct_cities).to eq(['Denver', 'Hershey'])
    end

    it 'active_orders' do
      user_1 = create :random_reg_user_test
      user_2 = create :random_reg_user_test
      target = Merchant.create!(name: "target", address: "100 some drive", city: "denver", state: "co", zip: 80023)
      walmart = Merchant.create!(name: "walmart", address: "100 some drive", city: "denver", state: "co", zip: 80023)
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: user_1.id, status: "Pending")
      order_2 = Order.create!(name: 'Brian', address: '123 Brian Ave', city: 'Denver', state: 'CO', zip: 17033, user_id: user_2.id, status: "Packaged")
      order_3 = Order.create!(name: 'Dao', address: '123 Mike Ave', city: 'Denver', state: 'CO', zip: 17033, user_id: user_2.id)
      order_4 = Order.create!(name: 'Dao', address: '123 Mike Ave', city: 'Denver', state: 'CO', zip: 17033, user_id: user_2.id)

      item = create(:item, merchant_id: target.id)
      item_2 = create(:item, merchant_id: target.id)
      item_3 = create(:item, merchant_id: target.id)
      item_4 = create(:item, merchant_id: walmart.id)

      order_1.item_orders.create!(item: item, price: @tire.price, quantity: 2)
      order_2.item_orders.create!(item: item_2, price: @tire.price, quantity: 2)
      order_3.item_orders.create!(item: item_3, price: @tire.price, quantity: 2)
      order_4.item_orders.create!(item: item_4, price: @tire.price, quantity: 2)

      expect(target.active_orders.count).to eq(3)
      expect(walmart.active_orders.count).to eq(1)
    end
  end
end
