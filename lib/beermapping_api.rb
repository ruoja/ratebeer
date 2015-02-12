class BeermappingApi

	def self.places_in(city)
		city = city.downcase
		Rails.cache.fetch(city, expires_in: 1.week) { fetch_places_in(city) }
	end

	def self.loc_map(place)
		street = place.street
		city = place.city
		fetch_map(street, city)
	end

	private

	def self.fetch_places_in(city)
		url = 'http://stark-oasis-9187.herokuapp.com/api/'
		response = HTTParty.get url + ERB::Util.url_encode(city)
		places = response.parsed_response['bmp_locations']['location']

		return [] if places.is_a?(Hash) and places['id'].nil?
		places = [places] if places.is_a?(Hash)
		places.inject([]) do | set, place |
			set << Place.new(place)   
		end
	end

	def self.fetch_map(street, city)
		url = 'https://www.google.com/maps/embed/v1/place?q='
		return url + ERB::Util.url_encode(street) + ',' + ERB::Util.url_encode(city) + '&key=' + mapkey
	end


	def self.key
		raise "APIKEY variable not defined" if ENV['APIKEY'].nil?
		ENV['APIKEY']
	end

	def self.mapkey
		raise "MAPKEY variable not defined" if ENV['MAPKEY'].nil?
		ENV['MAPKEY']
	end
end