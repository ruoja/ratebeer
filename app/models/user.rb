class User < ActiveRecord::Base
	include RatingAverage

	has_many :ratings, dependent: :destroy
	has_many :beers, through: :ratings
	has_many :memberships, dependent: :destroy
	has_many :beer_clubs, through: :memberships
	has_secure_password

	validates :username, uniqueness: true,
											 length: { in: 3..15 }
	validates :password, length: { minimum: 4 },
											 format: { with: /(?=.*[A-Z])(?=.*[0-9])/,
											 message: "must contain at least one number and one capital letter" }											 

	def favourite_beer
		return nil if ratings.empty?
		ratings.order(score: :desc).limit(1).first.beer
	end

	def favourite_style
		return nil if ratings.empty?
		style = ''
		avg = 0
		ratings.each do |rating|
			styleAvg = average_rating_by_style(rating.beer.style)
			unless avg > styleAvg
				avg = styleAvg
				style = rating.beer.style
			end
		end
		style
	end

	def favourite_brewery
		return nil if ratings.empty?
		brewery = ''
		avg = 0
		ratings.each do |rating|
			breweryAvg = average_rating_by_brewery(rating.beer.brewery.name)
			unless avg > breweryAvg
				avg = breweryAvg
				brewery = rating.beer.brewery.name
			end
		end
		brewery
	end

	def average_rating_by_style(style)
		scores = []
		ratings.each do |rating|
			if rating.beer.style == style
				scores << rating.score
			end
		end
		average_score(scores)
	end

	def average_score(scores)
		if scores.empty?
			return 0
		else
			(scores.sum / scores.length).round(2)
		end
	end

	def average_rating_by_brewery(brewery)
		scores = []
		ratings.each do |rating|
			if rating.beer.brewery.name == brewery
				scores << rating.score
			end
		end
		average_score(scores)
	end
	
end
