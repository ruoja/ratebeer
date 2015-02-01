class BeerClub < ActiveRecord::Base

	has_many :memberships, dependent: :destroy
	has_many :members, -> { uniq }, through: :memberships, source: :user

	def to_s
		"#{self.name}, #{self.city}"
	end	

end
