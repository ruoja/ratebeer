class PlacesController < ApplicationController

	before_action :set_place, only: [:show]

	def index
	end

	def show
	end

	def search
		@places = BeermappingApi.places_in(params[:city])
		if @places.empty?
			redirect_to places_path, notice: "No locations in #{params[:city]}"
		else
		session[:last_search] = params[:city]
		render :index
		end
	end

	private

	def set_place
		places = Rails.cache.read(session[:last_search])
		@place = places.detect { |p| p.id == params[:id] }
  end

end