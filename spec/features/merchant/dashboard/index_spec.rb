require "rails_helper"

RSpec.describe "as a merchant" do 
  describe "when I am logged in and on dashboard page (/merchant)" do 
    it "merchant dashboard show page shows me 1) Name and 2) Full address of the merchant I work for " do 

      @merchant_user = User.create!(name: "show merch", address: "show", city: "denver", state: "co", zip: 80023, role: 2, email: "joe@ge.com", password: "password") 
      
      @target = create :merchant

      @target.users << @merchant_user
      
      visit '/login'

      fill_in :email, with: @merchant_user.email
      fill_in :password, with: 'password'

      click_button 'Log In'

      visit '/merchant/dashboard'

      within "#merchant_dashboard-#{@merchant_user.merchant_id}" do 
        expect(page).to have_content(@target.name)
        expect(page).to have_content(@target.address)
        expect(page).to have_content(@target.city)
        expect(page).to have_content(@target.state)
        expect(page).to have_content(@target.zip)
      end 
    end 
    it "shows me a list of orders pending that I sell (if any) in a list -
        the ID of the order, which is a link to the order show page /merchant/orders/15)
        the date the order was made
        the total quantity of my items in the order
        the total value of my items for that order" do 

      merchant_user = User.create!(name: "show merch", address: "show", city: "denver", state: "co", zip: 80023, role: 2, email: "joe3@ge.com", password: "password") 
      regular_user = User.create!(name: "regular user", address: "show", city: "denver", state: "co", zip: 80023, role: 0, email: "joe2@ge.com", password: "password") 
      
      another_regular_user = User.create!(name: "another user", address: "show", city: "denver", state: "co", zip: 80023, role: 0, email: "joe4@ge.com", password: "password") 
      target = Merchant.create!(name: "target", address: "100 some drive", city: "denver", state: "co", zip: 80023) 

      target.users << merchant_user
        
      #order = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: regular_user.id, status: )
      item = create(:item, merchant_id: target.id)  
      item_2 = create(:item, merchant_id: target.id)  
      item_3 = create(:item, merchant_id: target.id) #make sure that this doeds not show on the dashboard  

      #log in as regular user #1
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user)

      visit item_path(item)
      click_button "Add To Cart"
      visit item_path(item_2)
      click_button "Add To Cart"

      visit cart_path
      click_link "Checkout" 

      fill_in :name, with: regular_user.name
      fill_in :address,  with: regular_user.address
      fill_in :city, with: regular_user.city
      fill_in :state, with: regular_user.state
      fill_in :zip, with: regular_user.zip

      click_button "Create Order"
      
      #log in as reg 2
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(another_regular_user)

      visit item_path(item)
      click_button "Add To Cart"
      visit item_path(item_2)
      click_button "Add To Cart"

      visit cart_path
      click_link "Checkout" 

      fill_in :name, with: another_regular_user.name
      fill_in :address,  with: another_regular_user.address
      fill_in :city, with: another_regular_user.city
      fill_in :state, with: another_regular_user.state
      fill_in :zip, with: another_regular_user.zip

      click_button "Create Order"

      #then log in as merchant
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

      visit merchant_dashboard_path

      within "#merchant_dashboard_orders" do 
        expect(page).to have_content("#{regular_user.orders.first.created_at}")
        expect(page).to have_content("#{regular_user.orders.first.total_quantity}")
        expect(page).to have_content("#{regular_user.orders.first.grandtotal}")

        click_link("#{regular_user.orders.first.id}")
        expect(current_path).to eq ("/merchant/orders/#{regular_user.orders.first.id}")
      end
    end

    it "can show me a list of items that I have a merchant" do 
      merchant_user = User.create!(name: "show merch", address: "show", city: "denver", state: "co", zip: 80023, role: 2, email: "joe3@ge.com", password: "password") 
      target = Merchant.create!(name: "target", address: "100 some drive", city: "denver", state: "co", zip: 80023) 

      target.users << merchant_user
        
      item = create(:item, merchant_id: target.id)  
      item_2 = create(:item, merchant_id: target.id)  
      item_3 = create(:item, merchant_id: target.id) #make sure that this doeds not show on the dashboard  

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

      visit merchant_dashboard_path

      click_link "View Items for #{target.name}"
       
      expect(page).to have_content(item.name)
      expect(page).to have_content(item_2.name)
      expect(page).to have_content(item_3.name)


    end 
  end
end

