# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
b1 = Brewery.create name:"Koff", year:1897
b2 = Brewery.create name:"Malmgard", year:2001
b3 = Brewery.create name:"Weihenstephaner", year:1042

b1.beers.create name:"Iso 3", style_id:1
b1.beers.create name:"Karhu", style_id:1
b1.beers.create name:"Tuplahumala", style_id:1
b2.beers.create name:"Huvila Pale Ale", style_id:2
b2.beers.create name:"X Porter", style_id:3
b3.beers.create name:"Hefeweizen", style_id:4
b3.beers.create name:"Helles", style_id:1

u1 = User.create username:"jani", password:"S4lasana", password_confirmation:"S4lasan4"
u2 = User.create username:"admin", password:"P4ssword", password_confirmation:"P4ssword"

u1.ratings.create beer:b1, score:22
u1.ratings.create beer:b2, score:28
u1.ratings.create beer:b3, score:17
u2.ratings.create beer:b1, score:24
u2.ratings.create beer:b2, score:29
u2.ratings.create beer:b3, score:20
