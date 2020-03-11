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
angie =  User.create!(name: "Angie Walker", email: "Angie@gmail.com", password: "123456", address: "Holzmarktstraße 54, 10179 Berlin", capacity: 10)
puts "created #{User.count} User"



puts "Creating Owners..."

o1 = Owner.create!(first_name: "Toni", last_name: "Panacek", telephone_number: 0301112233, email: "toni@email.com")
o2 = Owner.create!(first_name: "Steph", last_name: "Matsi", telephone_number: 0302223344, email: "steph@email.com")
o3 = Owner.create!(first_name: "Janis", last_name: "Vaneylen", telephone_number: 0303334455, email: "janis@email.com")
o4 = Owner.create!(first_name: "Teena", last_name: "Ajith", telephone_number: 0304445566, email: "teena@email.com")
o5 = Owner.create!(first_name: "Aurelia", last_name: "Nowak", telephone_number: 0305556677, email: "aurelia@email.com")

puts "Created #{Owner.count} Owners!"

puts "Creating Dogs..."

file = URI.open('https://res.cloudinary.com/batch371/image/upload/v1583747385/dog2_m5hzpp.jpg')
d1 = Dog.create!(owner: o1,
                 name: "Muffin",
                 pick_up_address: "Kremmener Str 11, Berlin",
                 breed: "Street-mix",
                 special_requirements: "needs a long leash",
                 user_id: angie.id)

d1.image.attach(io: file, filename: 'dog2_m5hzpp', content_type: 'image/jpg')

file = URI.open('https://res.cloudinary.com/batch371/image/upload/v1583747439/TG1FN8R6erHYQS1u2DZC8uHv.jpg')
d2 = Dog.create!(owner: o2,
                 name: "Otis",
                 pick_up_address: "Karl-lade-Str. 40, Berlin",
                 breed: "Chug",
                 special_requirements: "nut allergies",
                 user_id: angie.id)

d2.image.attach(io: file, filename: 'TG1FN8R6erHYQS1u2DZC8uHv', content_type: 'image/jpg')

file = URI.open('https://res.cloudinary.com/batch371/image/upload/v1583341941/iiupjeGCq8ETKHyqhLx6pzJn.jpg')
d3 = Dog.create!(owner: o3,
                 name: "Luna",
                 pick_up_address: "Dänenstraße 6, Berlin",
                 breed: "Husky",
                 special_requirements: "watch out for people on bikes",
                 user_id: angie.id)
d3.image.attach(io: file, filename: 'iiupjeGCq8ETKHyqhLx6pzJn', content_type: 'image/jpg')

file = URI.open('https://res.cloudinary.com/batch371/image/upload/v1583747385/dog.5_e5kmcx.jpg')
d4 = Dog.create!(owner: o4,
                 name: "Nino",
                 pick_up_address: "Alexanderplatz 10, Berlin",
                 breed: "Pug",
                 special_requirements: "none",
                 user_id: angie.id)
d4.image.attach(io: file, filename: 'dog.5_e5kmcx', content_type: 'image/jpg')


file = URI.open('https://res.cloudinary.com/batch371/image/upload/v1583747385/dog3_ms9lks.jpg')
d5 = Dog.create!(owner: o5,
                 name: "Cookie",
                 pick_up_address: "Turmstraße 91, 10551 Berlin",
                 breed: "Cockerl Spaniel",
                 special_requirements: "none",
                 user_id: angie.id)
d5.image.attach(io: file, filename: 'dog3_ms9lks', content_type: 'image/jpg')

file = URI.open('https://res.cloudinary.com/batch371/image/upload/v1583833246/husky.jpg')
d6 = Dog.create!(owner: o1,
                 name: "Karl",
                 pick_up_address: "Schützenstraße 11, 10117 Berlin",
                 breed: "Husky",
                 special_requirements: "none",
                 user_id: angie.id)
d6.image.attach(io: file, filename: 'husky', content_type: 'image/jpg')

file = URI.open('https://res.cloudinary.com/batch371/image/upload/v1583833246/labrador.jpg')
d7 = Dog.create!(owner: o2,
                 name: "Hugo",
                 pick_up_address: "Leipziger Str. 112, 10117 Berlin",
                 breed: "Labrador",
                 special_requirements: "none",
                 user_id: angie.id)
d7.image.attach(io: file, filename: 'labrador', content_type: 'image/jpg')

file = URI.open('https://res.cloudinary.com/batch371/image/upload/v1583833245/german_shepherd.jpg')
d8 = Dog.create!(owner: o3,
                 name: "Buddy",
                 pick_up_address: "Mauerstraße 51, 10117 Berlin",
                 breed: "German shepherd",
                 special_requirements: "none",
                 user_id: angie.id)
d8.image.attach(io: file, filename: 'german_shepherd', content_type: 'image/jpg')

file = URI.open('https://res.cloudinary.com/batch371/image/upload/v1583833245/dog.jpg')
d9 = Dog.create!(owner: o4,
                 name: "Charlie",
                 pick_up_address: "Dorotheenstraße 94, 10117 Berlin",
                 breed: "Dog",
                 special_requirements: "none",
                 user_id: angie.id)
d9.image.attach(io: file, filename: 'dog', content_type: 'image/jpg')

file = URI.open('https://res.cloudinary.com/batch371/image/upload/v1583833245/labradoodle.jpg')
d10 = Dog.create!(owner: o5,
                 name: "Milo",
                 pick_up_address: "Novalisstraße 11, 10115 Berlin",
                 breed: "Labradoodle",
                 special_requirements: "none",
                 user_id: angie.id)
d10.image.attach(io: file, filename: 'labradoodle', content_type: 'image/jpg')

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
s = Schedule.create!(monday: true, tuesday: true, wednesday: false, thursday: false, friday: true, dog:d6)
d6.schedule = s
s = Schedule.create!(monday: true, tuesday: false, wednesday: false, thursday: true, friday: true, dog:d7)
d7.schedule = s
s = Schedule.create!(monday: true, tuesday: true, wednesday: false, thursday: false, friday: true, dog:d8)
d8.schedule = s
s = Schedule.create!(monday: true, tuesday: false, wednesday: false, thursday: true, friday: false, dog:d9)
d9.schedule = s
s = Schedule.create!(monday: false, tuesday: false, wednesday: true, thursday: true, friday: true, dog:d10)
d10.schedule = s
puts "created #{Schedule.count} schedule"

# puts "creating Walks..."
# walk1 = Walk.create!(date: "08-03-2020",user: User.first)
# walk2 = Walk.create!(date:"09-03-2020", user: User.first)
# puts "created #{Walk.count} walks"

# puts "creating Slots..."
# Slot.create!(status:1, walk: walk1, dog: d2)
# Slot.create!(status:1, walk: walk1, dog: d4)
# Slot.create!(status:1, walk: walk1, dog: d5)
# Slot.create!(status:1, walk: walk2, dog: d1)
# Slot.create!(status:1, walk: walk2, dog: d2)
# Slot.create!(status:1, walk: walk2, dog: d3)
# Slot.create!(status:1, walk: walk2, dog: d5)

# puts "created #{Slot.count} slots"

