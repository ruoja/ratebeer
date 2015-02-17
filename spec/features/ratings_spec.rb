require 'rails_helper'
include OwnTestHelper

describe "Rating" do
	let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
	let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
	let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
	let!(:user) { FactoryGirl.create :user }

	before :each do
		sign_in(username:"Pekka", password:"Foobar1")
	end

	it "is registered to beer and current user when given" do
		visit new_rating_path
		select('iso 3', from:'rating[beer_id]')
		fill_in('rating[score]', with:'15')

		expect{
			click_button "Create Rating"
		}.to change{ Rating.count }.from(0).to(1)

		expect(user.ratings.count).to eq(1)
		expect(beer1.ratings.count).to eq(1)
		expect(beer1.average_rating).to eq(15.0)
	end

	it "total number of ratings is shown on ratings list page" do
		create_ratings(10, 15, 20, 25, 30, user)
		visit ratings_path

		expect(page).to have_content 'Total number of ratings: 5'
		expect(page).to have_content 'bisse'
		expect(page).to have_content '10'
		expect(page).to have_content 'Pekka'
	end
end	
