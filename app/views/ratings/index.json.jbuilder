json.array!(@all_ratings) do |rating|
  json.extract! rating, :id, :score
end
