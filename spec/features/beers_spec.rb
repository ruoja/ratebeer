require 'rails_helper'
include OwnTestHelper

describe "Beer" do
	let!(:style) { FactoryGirl.create :style }
	let!(:brewery) { FactoryGirl.create :brewery }
	let!(:user) { FactoryGirl.create :user }

	before :each do
		sign_in(username:"Pekka", password:"Foobar1")
	end

	it "is added to the system with nonempty name" do
		visit new_beer_path
		fill_in('beer[name]', with:'bisse')
		select('lager', from:'beer[style_id]')
		select('anonymous', from:'beer[brewery_id]')

		expect{ 
			click_button "Create Beer"
		}.to change{ Beer.count }.from(0).to(1)

		expect(page).to have_content 'Beer was successfully created.'
		expect(current_path).to eq(beers_path)
	end

	it "is not added to the system with empty name" do
		visit new_beer_path
		fill_in('beer[name]', with:'')
		select('lager', from:'beer[style_id]')
		select('anonymous', from:'beer[brewery_id]')

		click_button "Create Beer"

		expect(page).to have_content "Name can't be blank"
		expect(page).to have_content 'New Beer'
		expect(Beer.count).to eq(0)
	end	
end
