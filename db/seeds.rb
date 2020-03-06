# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require "open-uri"

puts "cleaning DB"

Schedule.destroy_all
Slot.destroy_all
Dog.destroy_all
User.destroy_all
Owner.destroy_all
Walk.destroy_all

puts "creating Users..."
angie =  User.create!(name: "Angie Walker", email: "Angie@gmail.com", password: "123456", address: "Alt-Treptow, 12435 Berlin", capacity: 10)
puts "created #{User.count} User"



puts "Creating Owners..."

o1 = Owner.create!(first_name: "Toni", last_name: "Panacek", telephone_number: 0301112233, email: "toni@email.com")
o2 = Owner.create!(first_name: "Steph", last_name: "Matsi", telephone_number: 0302223344, email: "steph@email.com")
o3 = Owner.create!(first_name: "Janis", last_name: "Vaneylen", telephone_number: 0303334455, email: "janis@email.com")
o4 = Owner.create!(first_name: "Teena", last_name: "Ajith", telephone_number: 0304445566, email: "teena@email.com")
o5 = Owner.create!(first_name: "Aurelia", last_name: "Nowak", telephone_number: 0305556677, email: "aurelia@email.com")

puts "Created #{Owner.count} Owners!"

puts "Creating Dogs..."
#binding.pry
file = URI.open('https://res.cloudinary.com/batch371/image/upload/v1583406161/dog_seed_2_uxrrj9.png')
d1 = Dog.create!(owner: o1,
                 name: "Muffin",
                 pick_up_address: "Kremmener Str 11, Berlin",
                 breed: "Street-mix",
                 special_requirements: "needs a long leash",
                 user_id: angie.id)

d1.image.attach(io: file, filename: 'dog_seed_2_uxrrj9', content_type: 'image/png')

file = URI.open('https://res.cloudinary.com/batch371/image/upload/v1583406178/dog_seed_5_j0vlop.jpg')
d2 = Dog.create!(owner: o2,
                 name: "Otis the great",
                 pick_up_address: "Karl-lade-Str. 40, Berlin",
                 breed: "Chug",
                 special_requirements: "nut allergies",
                 user_id: angie.id)

d2.image.attach(io: file, filename: 'dog_seed_5_j0vlop', content_type: 'image/png')

file = URI.open('https://res.cloudinary.com/batch371/image/upload/v1583341941/iiupjeGCq8ETKHyqhLx6pzJn.jpg')
d3 = Dog.create!(owner: o3,
                 name: "Luna",
                 pick_up_address: "Dänenstraße 6, Berlin",
                 breed: "Husky",
                 special_requirements: "watch out for people on bikes",
                 user_id: angie.id)
d3.image.attach(io: file, filename: 'iiupjeGCq8ETKHyqhLx6pzJn', content_type: 'image/jpg')

file = URI.open('https://res.cloudinary.com/batch371/image/upload/v1583341356/i1iEcFJMquATzH4H6uCC8zdv.png')
d4 = Dog.create!(owner: o4,
                 name: "Nino",
                 pick_up_address: "Alexanderplatz 10, Berlin",
                 breed: "Pug",
                 special_requirements: "none",
                 user_id: angie.id)
d4.image.attach(io: file, filename: 'i1iEcFJMquATzH4H6uCC8zdv', content_type: 'image/png')

file = URI.open('https://res.cloudinary.com/batch371/image/upload/v1583337843/LLmWdcNnqPTrGqYg8yo1oatC.png')
d5 = Dog.create!(owner: o5,
                 name: "Cookie",
                 pick_up_address: "Turmstraße 73, Berlin",
                 breed: "Cockerl Spaniel",
                 special_requirements: "none",
                 user_id: angie.id)
d5.image.attach(io: file, filename: 'LLmWdcNnqPTrGqYg8yo1oatC', content_type: 'image/png')

puts "Created #{Dog.count} Dogs"


puts "Creating Schedules..."

s = Schedule.create!(monday: true, tuesday: true, wednesday: false, thursday: false, friday: true, dog:d1)
d1.schedule = s
s = Schedule.create!(monday: true, tuesday: false, wednesday: false, thursday: true, friday: true, dog:d2)
d2.schedule = s
s = Schedule.create!(monday: true, tuesday: true, wednesday: false, thursday: false, friday: true, dog:d3)
d3.schedule = s
s = Schedule.create!(monday: true, tuesday: false, wednesday: false, thursday: true, friday: false, dog:d4)
d4.schedule = s
s = Schedule.create!(monday: false, tuesday: false, wednesday: true, thursday: true, friday: true, dog:d5)
d5.schedule = s
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



