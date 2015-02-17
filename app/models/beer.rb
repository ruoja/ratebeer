class Beer < ActiveRecord::Base
	include RatingAverage

	belongs_to :brewery
	belongs_to :style
	has_many :ratings, dependent: :destroy
	has_many :raters, -> { uniq }, through: :ratings, source: :user

	validates :name, :style, presence: true

	def to_s
		"#{self.name} by #{self.brewery.name}"
	end	

	def average
		return 0 if ratings.empty?
		(ratings.map { |r| r.score }.sum / ratings.count.to_f).round(2)
	end

	def self.top(n)
		last = n - 1
   	sorted_by_rating_in_desc_order = Beer.all.sort_by{ |b| -(b.average_rating||0) }
   	sorted_by_rating_in_desc_order[0..last]
 end
		
end
