# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

25.times do
  Profile.create! :name => Faker::Name.name, :email => Faker::Internet.email, :username => Faker::Internet.user_name
end

User.create! :email => "user@example.com", :password => "doorkeeper", :password_confirmation => "doorkeeper"

app = Doorkeeper::Application.create! :name => "Doorkeeper Sinatra Client", :redirect_uri => "http://localhost:3000/callback"

puts "Application: "
puts "name: #{app.name}"
puts "redirect_uri: #{app.redirect_uri}"
puts "uid: #{app.uid}"
puts "secret: #{app.secret}"
