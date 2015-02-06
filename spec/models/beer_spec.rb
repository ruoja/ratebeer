require 'rails_helper'

RSpec.describe Beer, :type => :model do

	it "is not saved without name" do
		beer = Beer.create name:"", style:"lager"

		expect(beer).not_to be_valid
		expect(Beer.count).to eq(0)
	end

	it "is not saved without style" do
		beer = Beer.create name:"bisse", style:""

		expect(beer).not_to be_valid
		expect(Beer.count).to eq(0)
	end

	describe "when name and style are set" do

		let(:beer){ FactoryGirl.create(:beer) }

		it "is saved" do
			expect(beer).to be_valid
			expect(Beer.count).to eq(1)
		end
	end
end
