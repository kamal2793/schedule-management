# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


10.times do
  user = User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: '12345678'
  )

  user.create_patient()
end

10.times do
  user = User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: '12345678'
  )

  user.create_doctor()
end


start_time = Time.zone.now.beginning_of_day
end_time = Time.zone.now.end_of_day
duration = 30.minutes
while end_time > start_time
  Slot.create(start_time: start_time.strftime("%H:%M"), end_time: (start_time + duration).strftime("%H:%M") )
  start_time += duration
end

Slot.create(start_time: '23:30:00', end_time: '23:59:59')


u = Doctor.first.user
u.email = 'd@gmail.com'
u.save!

u = Doctor.second.user
u.email = 'd2@gmail.com'
u.save!

u = Patient.first.user
u.email = 'p@gmail.com'
u.save!

u = Patient.second.user
u.email = 'p2@gmail.com'
u.save!