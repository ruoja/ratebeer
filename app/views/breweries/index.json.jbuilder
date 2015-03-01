json.array!(@all_breweries) do |brewery|
  json.extract! brewery, :id, :name, :year
end
