# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

10.times {
  user = User.new
  user.first_name = Faker::Name.first_name
  user.last_name = Faker::Name.last_name
  user.password = "123456"
  user.address = Faker::Address.street_address + " " + Faker::Address.city
  user.email = Faker::Internet.email
  user.latitude = Faker::Address.latitude
  user.longitude = Faker::Address.longitude
  user.save
}
