class Style < ActiveRecord::Base
  include RatingAverage

	has_many :beers
  has_many :ratings, through: :beers

	def to_s
		"#{self.name}"
  end

  def self.top(n)
    last = n - 1
    sorted_by_rating_in_desc_order = Style.all.sort_by{ |style| -(style.average_rating||0) }
    sorted_by_rating_in_desc_order[0..last]
  end
end
