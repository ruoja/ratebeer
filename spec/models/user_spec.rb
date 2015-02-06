require 'rails_helper'
include OwnTestHelper

RSpec.describe User, :type => :model do

  it "has the username set correctly" do
  	user = User.new username:"Pekka"

  	expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
  	user = User.create username:"Pekka"

  	expect(user).not_to be_valid
  	expect(User.count).to eq(0)
  end

  it "is not saved with too short password" do
    user = User.create username:"Pekka", password:"S3c", password_confirmation:"S3c"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with invalid password" do
    user = User.create username:"Pekka", password:"secret", password_confirmation:"secret"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with proper password" do

  	let(:user){ FactoryGirl.create(:user) }

  	it "is saved" do
  		expect(user).to be_valid
  		expect(User.count).to eq(1)
  	end

  	it "has correct average rating with two ratings" do
  		user.ratings << FactoryGirl.create(:rating)
			user.ratings << FactoryGirl.create(:rating2)

			expect(user.ratings.count).to eq(2) 
			expect(user.average_rating).to eq(15.0)
		end
  end

  describe "favourite_beer" do

    let(:user){ FactoryGirl.create(:user) }

    it "can be determined" do
      expect(user).to respond_to(:favourite_beer)
    end

    it "does not exist without ratings" do
      expect(user.favourite_beer).to eq(nil)
    end

    it "is the only rated beer if there's only one rating" do
      beer = create_beer_with_rating(10, user)

      expect(user.favourite_beer).to eq(beer)
    end

    it "is the highest rated beer if there's many ratings" do
      create_beers_with_ratings(10, 20, 15, 7, 9, user)
      best = create_beer_with_rating(25, user)
      
      expect(user.favourite_beer).to eq(best)
    end
  end
end