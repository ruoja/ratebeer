require 'rails_helper'
include OwnTestHelper

describe "User" do
	let!(:user) { FactoryGirl.create :user }
	
	it "is added to the system when signed up with good credentials" do
		visit signup_path
		fill_in('user_username', with:'Brian')
		fill_in('user_password', with:'Secret55')
		fill_in('user_password_confirmation', with:'Secret55')

		expect {
			click_button('Create User')
		}.to change {User.count}.by(1)
	end

	it "has total number of users own ratings on users page" do
		user1 = create_user_with_ratings(1, 2, 3, 4, 5, 6, 7, "Tupu")
		user2 = create_user_with_ratings(10, 20, 30, 40, 50, "Hupu")
		user3 = create_user_with_ratings(11, 22, 33, "Lupu")
			
		visit user_path(user1)
		expect(page).to have_content 'Has 7 ratings, average: 4.0'
		expect(page).to have_content 'no beer club memberships'

		visit user_path(user2)
		expect(page).to have_content 'Has 5 ratings, average: 30.0'

		visit user_path(user3)
		expect(page).to have_content 'Has 3 ratings, average: 22.0'

		expect(Rating.count).to eq(15)
		expect(user1.ratings.count).to eq(7)
		expect(user2.ratings.count).to eq(5)
		expect(user3.ratings.count).to eq(3)
	end

	it "is redirected back to signin with wrong credentials" do
			sign_in(username:"Pekka", password:"wrong")
			expect(current_path).to eq(signin_path)
			expect(page).to have_content 'Username and/or password missmatch'
	end

	describe "who is signed up" do
		
		before :each do
			sign_in(username:"Pekka", password:"Foobar1")
		end

		it "can signin with right credentials" do
			expect(page).to have_content 'Welcome Pekka!'
			expect(page).to have_content 'Pekka'
		end

		it "can remove his own ratings when signed in" do
			create_beers_with_ratings(10, 15, 20, 25, 30, user)
			visit user_path(user)
			expect{
				page.first(:link, "delete").click
			}.to change{ user.ratings.count }.from(5).to(4)	
		end

	end
end

def create_user_with_ratings(*scores, username)
	user = FactoryGirl.create :user, username:username, password:"Foobar1", password_confirmation:"Foobar1"
	scores.each do |score|
		create_rating(score, user)
	end
	user 
end

