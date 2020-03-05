# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "cleaning DB"

Schedule.destroy_all
Slot.destroy_all
Dog.destroy_all
User.destroy_all
Owner.destroy_all
Walk.destroy_all

puts "creating Owners..."
owner1 = Owner.create!(first_name: "Danny")
owner2 = Owner.create!(first_name: "Mari")
owner3 = Owner.create!(first_name: "Kelly")
puts "created #{Owner.count} Owners"

puts "creating Dogs..."
# Dog.create!(name: "Otis the great", pick_up_address: "Karl-lade-Str. 40, Berlin", breed: "Chug", special_requirements: "nut allergies")
# Dog.create!(name: "Muffin", pick_up_address: "Kremmener Str 11, Berlin", breed: "Street-mix", special_requirements: "needs a long leash")
# Dog.create!(name: "Luna", pick_up_address: "Dänenstraße 6, Berlin", breed: "Husky", special_requirements: "watch out for people on bikes")
# Dog.create!(name: "Nino", pick_up_address: "Alexanderplatz 10, Berlin", breed: "Pug", special_requirements: "none")
# Dog.create!(name: "Hugo", pick_up_address: "Chausseestraße 87, Berlin", breed: "Bulldog", special_requirements: "needs a muzzle")
# Dog.create!(name: "Hulk", pick_up_address: "Invalidenstraße 3, Berlin", breed: "German Shepherd", special_requirements: "none")
d1 = Dog.create!(name: "T-Bone", pick_up_address: "Bernauer Straße 22, Berlin", breed: "Akita", special_requirements: "none", owner: owner2)
d2 = Dog.create!(name: "Jimmy", pick_up_address: "Kaiserdamm 65, Berlin", breed: "Chug", special_requirements: "none", owner: owner1)
d3 = Dog.create!(name: "Bobby", pick_up_address: "Kopenhagener Straße 1, Berlin", breed: "Beagle", special_requirements: "none", owner: owner1)
d4 = Dog.create!(name: "Gizzmo", pick_up_address: "Warschauer Straße 38, Berlin", breed: "Shiba", special_requirements: "none", owner: owner2)
d5 = Dog.create!(name: "Cookie", pick_up_address: "Turmstraße 73, Berlin", breed: "Cockerl Spaniel", special_requirements: "none", owner: owner3)
puts "created #{Dog.count} Dogs"

puts "creating Users..."
User.create!(name: "Angie Walker", email: "Angie@gmail.com", password: "123456", address: "Alt-Treptow, 12435 Berlin", capacity: 10)
puts "created #{User.count} User"

puts "creating Schedules..."
Schedule.create!(monday: true, tuesday: true, wednesday: false, thursday: false, friday: true, dog:d1)
Schedule.create!(monday: true, tuesday: false, wednesday: false, thursday: true, friday: true, dog:d2)
Schedule.create!(monday: true, tuesday: true, wednesday: false, thursday: false, friday: true, dog:d3)
Schedule.create!(monday: true, tuesday: false, wednesday: false, thursday: true, friday: false, dog:d4)
Schedule.create!(monday: false, tuesday: false, wednesday: true, thursday: true, friday: true, dog:d5)
puts "created #{Schedule.count} schedule"

puts "creating Walks..."
walk1 = Walk.create!(date: "05-03-2020",user: User.first)
walk2 = Walk.create!(date:"06-03-2020", user: User.first)
puts "created #{Walk.count} walks"

puts "creating Slots..."
Slot.create!(status:1, walk: walk1, dog: d2)
Slot.create!(status:1, walk: walk1, dog: d4)
Slot.create!(status:1, walk: walk1, dog: d5)
Slot.create!(status:1, walk: walk2, dog: d1)
Slot.create!(status:1, walk: walk2, dog: d2)
Slot.create!(status:1, walk: walk2, dog: d3)
Slot.create!(status:1, walk: walk2, dog: d5)

puts "created #{Slot.count} slots"
