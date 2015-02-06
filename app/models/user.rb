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
		#beers.group(:style).order('count_id DESC').limit(1).count(:id).keys[0]
		return 'lager'
	end

	def favourite_brewery
		return nil if ratings.empty?
		return 'anonymous'
	end

	def average_rating_by_style(style)
		scores = []
		hash = {}
		ratings.each do |rating|
			if rating.beer.style == style
				scores << rating.score
			end
		end
		hash[:style] = style
		hash[:avg] = style_average(scores)
		hash
	end

	def style_average(scores)
		if scores.empty?
			return 0
		else
			(scores.sum / scores.length).round(2)
		end
	end
	
end
