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
  # user.address = "Paris"
  user.email = Faker::Internet.email
  user.latitude = rand(48.83..48.88)
  user.longitude = rand(2.3..2.38)
  user.pro = true
  user.role = ["Photographer", "Videographer", "Drone Pilot"].sample
  user.save
}
