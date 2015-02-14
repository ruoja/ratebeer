require 'rails_helper'

RSpec.describe Beer, :type => :model do
	let(:style){ FactoryGirl.create(:style) }

	it "is not saved without name" do
		beer = Beer.create name:"", style:style

		expect(beer).not_to be_valid
		expect(Beer.count).to eq(0)
	end

	it "is not saved without style" do
		beer = Beer.create name:"bisse"

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
