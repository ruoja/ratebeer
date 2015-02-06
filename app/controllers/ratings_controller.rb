class RatingsController < ApplicationController
	before_action :set_beers_for_template, only: [:new]
	before_action :ensure_that_signed_in, except: [:index, :show]

		def index
		@ratings = Rating.all
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

end