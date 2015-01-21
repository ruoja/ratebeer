module RatingAverage
	extend ActiveSupport::Concern

	def average_rating
		ratings = self.ratings.collect {
			|rating| rating.score
		} 
		sum = ratings.reduce :+
		unless sum == nil
			sum.to_f / self.ratings.count
		end
	end

end