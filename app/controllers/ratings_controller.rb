class RatingsController < ApplicationController
	before_action :set_beers_for_template, only: [:new]
	before_action :ensure_that_signed_in, except: [:index, :show]

	def index
		#@all_ratings = Rails.cache.read('all ratings')
		#@recent_ratings = Rails.cache.read('recent ratings')
		#@best_beers = Rails.cache.read('top beers')
		#@best_breweries = Rails.cache.read('top breweries')
    #@best_styles = Rails.cache.read('top styles')
		#@most_active_users = Rails.cache.read('most active users')
		@all_ratings = Rating.all
		@recent_ratings = Rating.recent
		@best_beers = top 3, Beer
		@best_breweries = top 3, Brewery
    @best_styles = top 3, Style
		@most_active_users = User.most_active 3
	end

	def new
		@rating = Rating.new
	end
	
	def create
		@rating = Rating.new params.require(:rating).permit(:score, :beer_id)
		
		if @rating.save
			current_user.ratings << @rating
			redirect_to current_user
		else
			set_beers_for_template
			render :new
		end	
	end

	def destroy
		rating = Rating.find(params[:id])
		rating.delete if current_user == rating.user
		redirect_to :back
	end

	private

		def set_beers_for_template
			@beers = Beer.all
		end

		#def background_worker
    #	while true do
    #   	Rails.cache.write("all ratings", Rating.all)
    #   	Rails.cache.write("recent ratings", Rating.recent)
    #   	Rails.cache.write("top beers", top(3, Beer))
    #   	Rails.cache.write("top breweries", top(3, Brewery))
    #   	Rails.cache.write("top styles", top(3, Style))
    #   	Rails.cache.write("most active users", User.most_active(3))
    #    sleep 10.minutes
    #	end
  	#end

end