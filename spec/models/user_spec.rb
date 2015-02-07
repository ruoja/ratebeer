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

  describe "favourite_style" do
    let(:user){ FactoryGirl.create(:user) }

    it "can be determined" do
      expect(user).to respond_to(:favourite_style)
    end

    it "is the style of only rated beer if there's only one rating" do
      create_beer_with_rating(20, user)
      expect(user.favourite_style).to eq('lager')
    end

    it "is the style with highest average rating if there's many ratings" do
      beer1 = create_beer_with_rating(5, user)
      FactoryGirl.create(:rating, score:32, beer:beer1, user:user)
      FactoryGirl.create(:rating, score:3, beer:beer1, user:user)
      beer2 = FactoryGirl.create(:beer, style:"IPA")
      FactoryGirl.create(:rating, score:10, beer:beer2, user:user)
      FactoryGirl.create(:rating, score:20, beer:beer2, user:user)
      FactoryGirl.create(:rating, score:30, beer:beer2, user:user)

      expect(user.favourite_style).to eq('IPA')
    end  
    
  end

  describe "favourite_brewery" do
    let(:user){ FactoryGirl.create(:user) }

    it "can be determined" do
      expect(user).to respond_to(:favourite_brewery)
    end

    it "is the brewery of only rated beer if there's only one rating" do
      create_beer_with_rating(20, user)
      expect(user.favourite_brewery.name).to eq('anonymous')
    end

    it "is the brewery whose beers have the highest average rating if there's many ratings" do
      brewery = FactoryGirl.create(:brewery, name:"panimo")
      beer2 = FactoryGirl.create(:beer, brewery:brewery)
      FactoryGirl.create(:rating, score:22, beer:beer2, user:user)
      FactoryGirl.create(:rating, score:28, beer:beer2, user:user)
      FactoryGirl.create(:rating, score:30, beer:beer2, user:user)
      beer1 = create_beer_with_rating(2, user)
      FactoryGirl.create(:rating, score:3, beer:beer1, user:user)
      FactoryGirl.create(:rating, score:50, beer:beer1, user:user)

      expect(user.favourite_brewery.name).to eq('panimo')
    end
  end      
end