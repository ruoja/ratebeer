module RatingAverage
	extend ActiveSupport::Concern

	def average_rating 
		return 0 if self.ratings.empty?
		(ratings.map { |r| r.score }.sum / ratings.count.to_f).round(2)
	end

	def styles
		s = Set.new
		beers.each do |b| 
			s.add(b.style)  
		end
		s
	end

end