class Beer < ActiveRecord::Base
	include RatingAverage

	belongs_to :brewery, touch: true
	belongs_to :style
	has_many :ratings, dependent: :destroy
	has_many :raters, -> { uniq }, through: :ratings, source: :user

	validates :name, :style, presence: true

	def to_s
		"#{self.name} by #{self.brewery.name}"
	end	

end
