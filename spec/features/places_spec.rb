require 'rails_helper'

describe "Places" do

	it "is shown on the page if one is returned by the API" do
		allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
			[ Place.new( name:"Oljenkorsi", id: 1 ) ]
		)

		visit places_path
		fill_in('city', with: 'kumpula')
		click_button 'Search'

		expect(page).to have_content "Oljenkorsi"
	end

	it "shows all on the page if many places is returned by the API" do
		allow(BeermappingApi).to receive(:places_in).with("kontula").and_return(
			[ Place.new( name:"Aapelin baari", id: 1 ),
			Place.new( name:"Pub Oslo", id: 2 ),
			Place.new( name:"Kippari Pub", id: 3 ) ]
		)

		visit places_path
		fill_in('city', with: 'kontula')
		click_button 'Search'

		expect(page).to have_content "Aapelin baari"
		expect(page).to have_content "Pub Oslo"
		expect(page).to have_content "Kippari Pub"
	end

	it "shows a notice if the API returns no results" do
		allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
			[] 
		)

		visit places_path
		fill_in('city', with: 'kumpula')
		click_button 'Search'

		expect(page).to have_content "No locations in kumpula"
	end
end	