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
    favourite :style
	end

	def favourite_brewery
    favourite :brewery
	end

	def self.most_active(n)
		last = n - 1
   	sorted_by_rating_count_in_desc_order = User.all.sort_by{ |u| -(u.ratings.count||0) }
   	sorted_by_rating_count_in_desc_order[0..last]
 end

	private

    def rated(category)
      ratings.map{ |r| r.beer.send(category) }
    end

    def rating_of(category, item)
      ratings_of_item = ratings.select do
        |r| r.beer.send(category) == item
      end
      ratings_of_item.map(&:score).sum / ratings_of_item.count
    end

    def favourite(category)
      return nil if ratings.empty?
      category_ratings = rated(category).inject([]) do |set, item|
        set << {
          item: item,
          rating: rating_of(category, item) }
      end
      category_ratings.sort_by{ |item| item[:rating] }.last[:item]
    end

end
