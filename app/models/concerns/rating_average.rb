module RatingAverage
	extend ActiveSupport::Concern

	def average_rating 
		return 0 if self.ratings.empty?
		(ratings.map { |r| r.score }.sum / ratings.count.to_f).round(2)
	end

	def styles
		ratings.map { |r| r.beer.style }.to_set
	end

end