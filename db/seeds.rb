require 'random_data'
5.times do
  User.create!(
    username: Faker::Internet.user_name,
    email:    Faker::Internet.email,
    password: Faker::Internet.password(8)
  )
end
users = User.all

20.times do
  wiki = Wiki.create!(
    user:   users.sample,
    title:  Faker::Hipster.sentence(2),
    body:   Faker::Hipster.paragraph(3),
    private: false
  )
  wiki.update_attribute(:created_at, rand(10.minutes..1.year).ago)
end

User.create!(
  username: 'Alyssa',
  email:    'alybeic@gmail.com',
  password: 'password'
)

puts 'Seed finished'
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"
