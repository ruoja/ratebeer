FactoryGirl.define do

	factory :user do
		username "Pekka"
		password "Foobar1"
		password_confirmation "Foobar1"
	end

	factory :rating do
		score 10
	end

	factory :rating2, class: Rating do
		score 20
	end

	factory :brewery do
		name "anonymous"
		year 1900
		active true
	end

	factory :brewery2, class: Brewery do
		name "panimo"
		year 1950
	end

	factory :beer do
		name "bisse"
		brewery
		style
	end

	factory :beer2, class: Beer do
		name "kalja"
		brewery2
		style2
	end

	factory :beer_club do
		name "kerho"
		founded 2000
		city "gotham"
	end

	factory :style do
		name "lager"
		description "some descriptive text"
	end

	factory :style2, class: Style do
		name "ale"
		description "some descriptive text"
	end

end