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
		favStyle = nil
		max = 0
    styles_with_ratings.each do |style_id|
      avg = avg_rating(ratings_by_style(style_id))
      if max < avg
        max = avg
        favStyle = Style.find style_id
      end
    end
    favStyle
	end

	def favourite_brewery
		favBrewery = nil
		max = 0
		breweries_with_ratings.each do |brewery_id|
			avg = avg_rating(ratings_by_brewery(brewery_id))
			if max < avg
				max = avg
				favBrewery = Brewery.find brewery_id
			end
		end
		favBrewery
	end

	def self.most_active(n)
		last = n - 1
   	sorted_by_rating_count_in_desc_order = User.all.sort_by{ |u| -(u.ratings.count||0) }
   	sorted_by_rating_count_in_desc_order[0..last]
 end

	private
  	def ratings_by_style(style_id)
    	ratings.joins(:beer).where("beers.style_id = ?", style_id)
  	end

  	def ratings_by_brewery(brewery_id)
    	ratings.joins(:beer).where("beers.brewery_id = ?", brewery_id)
  	end

  	def avg_rating(ratings)
  		return 0 if ratings.empty?
    	(ratings.map { |rating| rating.score }.sum / ratings.count).round(2)
  	end

  	def styles_with_ratings
    	beers.select(:style_id).distinct.map { |beer| beer.style_id }
  	end

  	def breweries_with_ratings
    	beers.select(:brewery_id).distinct.map { |beer| beer.brewery_id } 
  	end
  
end
