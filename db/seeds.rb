# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "cleaning DB"

Dog.destroy_all
User.destroy_all
Owner.destroy_all
Walk.destroy_all
Schedule.destroy_all
Slot.destroy_all

puts "creating Dogs..."

Dog.create!(name: "Otis the great", pick_up_address: "Karl-lade-Str. 40, Berlin", breed: "Chug", special_requirements: "nut allergies")
Dog.create!(name: "Muffin", pick_up_address: "Kremmener Str 11, Berlin", breed: "Street-mix", special_requirements: "needs a long leash")
Dog.create!(name: "Luna", pick_up_address: "Dänenstraße 6, Berlin", breed: "Husky", special_requirements: "watch out for people on bikes")
Dog.create!(name: "Nino", pick_up_address: "Alexanderplatz 10, Berlin", breed: "Pug", special_requirements: "none")
Dog.create!(name: "Hugo", pick_up_address: "Chausseestraße 87, Berlin", breed: "Bulldog", special_requirements: "needs a muzzle")
Dog.create!(name: "Hulk", pick_up_address: "Invalidenstraße 3, Berlin", breed: "German Shepherd", special_requirements: "none")
Dog.create!(name: "T-Bone", pick_up_address: "Bernauer Straße 22, Berlin", breed: "Akita", special_requirements: "none")
Dog.create!(name: "Jimmy", pick_up_address: "Kaiserdamm 65, Berlin", breed: "Chug", special_requirements: "none")
Dog.create!(name: "Bobby", pick_up_address: "Kopenhagener Straße 1, Berlin", breed: "Beagle", special_requirements: "none")
Dog.create!(name: "Gizzmo", pick_up_address: "Warschauer Straße 38, Berlin", breed: "Shiba", special_requirements: "none")
Dog.create!(name: "Cookie", pick_up_address: "Turmstraße 73, Berlin", breed: "Cockerl Spaniel", special_requirements: "none")

puts "created #{Dog.count} Dogs"

User.create!(name: "Angie Walker", email: "Angie@gmail.com", password: "123456", address: "Alt-Treptow, 12435 Berlin", capacity: 10)

puts "created #{User.count} User"

walk1 = Walk.create!("04-03-2020")
walk2 = Walk.create!(date:"05-03-2020")
Slot.create(status:1,place:3,walk:Walk.last,dog:Dog.last)
Slot.create(status:1,place:2,walk:Walk.last,dog:Dog.first)
Slot.create(status:1,place:1,walk:Walk.last,dog:Dog.find(3))
