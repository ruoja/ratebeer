module RatingAverage
	extend ActiveSupport::Concern

	def average_rating 
		return 0 if self.ratings.empty?
		ratings.map { |r| r.score }.sum / ratings.count.to_f
	end

end