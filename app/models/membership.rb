class Membership < ActiveRecord::Base

	belongs_to :beer_club
	belongs_to :user

	validate :user_can_be_member_of_beer_club_only_once 

	def to_s
		"#{self.user.username}, #{self.beer_club.name}"
	end

	def user_can_be_member_of_beer_club_only_once
		user.memberships.each do |m| 
			if m.beer_club.id == self.beer_club_id
				false
				errors.add(:beer_club_id, "you are already a member")
			end
		end
	end		
	
end
