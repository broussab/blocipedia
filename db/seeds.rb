require 'random_data'
5.times do
  User.create!(
    # #3
    username:     RandomData.random_username,
    email:    RandomData.random_email,
    password: RandomData.random_sentence
  )
end
users = User.all

20.times do
  wiki = Wiki.create!(
    user:   users.sample,
    title:  RandomData.random_sentence,
    body:   RandomData.random_paragraph,
    private: false
  )
  wiki.update_attribute(:created_at, rand(10.minutes..1.year).ago)
end

puts 'Seed finished'
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"
