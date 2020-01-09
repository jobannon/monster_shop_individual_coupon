require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      @user = create :random_reg_user_test
      @coffee = create_list(:item, 10, merchant: @meg, inventory: 10)
      @orders = create_list(:order, 10, user: @user)

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
    end

    it "all items or merchant names are links" do
      visit '/items'

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)
      expect(page).to_not have_link(@dog_bone.name)
      expect(page).to have_link(@dog_bone.merchant.name)
    end

    it "I can see a list of all of the items as a default user"do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end

      expect(page).to_not have_css("#item-#{@dog_bone.id}")
      expect(page).to_not have_link(@dog_bone.name)
      expect(page).to_not have_content(@dog_bone.description)
      expect(page).to_not have_content("Price: $#{@dog_bone.price}")
      expect(page).to_not have_content("Inactive")
      expect(page).to_not have_content("Inventory: #{@dog_bone.inventory}")
      expect(page).to_not have_css("img[src*='#{@dog_bone.image}']")
    end

    it "shows me a page with statistics of my items" do

        item_1 = create(:item)
        item_order_1 = create(:item_order, item_id: item_1.id, quantity: 5)
        item_order_7 = create(:item_order, item_id: item_1.id, quantity: 5)

        item_2 = create(:item)
        item_order_2 = create(:item_order, item_id: item_2.id, quantity: 4)

        item_3 = create(:item)
        item_order_3 = create(:item_order, item_id: item_3.id, quantity: 3)

        item_4 = create(:item)
        item_order_4 = create(:item_order, item_id: item_4.id, quantity: 2)

        item_5 = create(:item)
        item_order_5 = create(:item_order, item_id: item_5.id, quantity: 1)

        item_6 = create(:item)
        item_order_6 = create(:item_order, item_id: item_6.id, quantity: 0)

        visit '/items'

        within ".top_five_0" do
          expect(page).to have_content(item_1.name)
          expect(page).to have_content(10)
        end
        within ".top_five_1" do
          expect(page).to have_content(item_2.name)
          expect(page).to have_content(4)
        end
        within ".top_five_2" do
          expect(page).to have_content(item_3.name)
          expect(page).to have_content(3)
        end
        within ".top_five_3" do
          expect(page).to have_content(item_4.name)
          expect(page).to have_content(2)
        end
        within ".top_five_4" do
          expect(page).to have_content(item_5.name)
          expect(page).to have_content(1)
        end
        within ".top" do
          expect(page).to_not have_content(item_6.name)
        end

    end

    it "shows that the image is a link" do
      visit "/items"

      page.find("#img_link-#{@pull_toy.id}" ).click

      expect(current_path).to eq("/items/#{@pull_toy.id}")
    end
  end
end
