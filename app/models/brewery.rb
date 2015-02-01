class Brewery < ActiveRecord::Base
	include RatingAverage
	
	has_many :beers, dependent: :destroy
	has_many :ratings, through: :beers

	validates :name, presence: true
	validates :year, numericality: { greater_than_or_equal_to: 1042 }
	validate :brewery_cannot_be_found_in_the_future, on: :create

	def print_report
		puts self.name
		puts "established at year #{self.year}"
		puts "number of beers #{self.beers.count}"
	end

	def restart
		self.year = 2015
		puts "changed year to #{year}"
	end

	def brewery_cannot_be_found_in_the_future
		if year.nil?
			false
		elsif year > DateTime.now.year
			errors.add(:year, "can't be in the future")	
		end
	end

end
