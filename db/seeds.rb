# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


10.times do
  user = User.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email
  )

  user.create_patient()
end

10.times do
  user = User.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email
  )

  user.create_doctor()
end


start_time = DateTime.strptime('00:00', '%H:%M')
end_time = DateTime.strptime('23:59', '%H:%M')
duration = 30.minutes
while end_time > start_time
  Slot.create(start_time: start_time.strftime("%H:%M"), end_time: (start_time + duration).strftime("%H:%M") )
  start_time += duration
end
Slot.where(end_time: '00:00:00').update_all(end_time: '23:59:59')


