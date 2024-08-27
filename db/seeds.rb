# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'date'

RunningSession.delete_all
Run.delete_all
Program.delete_all
User.delete_all

user = User.create!(
  email: "exemple1@email.com",
  password: "12345678",
  first_name: "Paul",
  weight: 80,
  age: 25,
  vma: 12
)

puts "#{User.count} user created ! "

program = Program.create!(
  objective_km: 42.195,
  objective_time: 195,
  race_date: Date.new(2024, 11, 13),
  free_days: [0, 2, 3, 5],
  user_id: user.id
)

puts "#{Program.count} program created ! "

run1 = Run.create!(
  run_interval_km: 10,
  run_interval_pace: 11,
  hr_zone: "Zone 2",
  difficulty: 2,
  kind: "Easy run"
)

run2 = Run.create!(
  run_interval_km: 23,
  run_interval_pace: 10,
  hr_zone: "Zone 3",
  difficulty: 3,
  kind: "Long run"
)

run3 = Run.create!(
  run_interval_time: 2,
  run_interval_pace: 14,
  rest_interval_pace: 0,
  rest_interval_time: 1,
  hr_zone: "Zone 5",
  difficulty: 5,
  kind: "Interval run",
  run_interval_nbr: 10
)

puts "#{Run.count} runs created ! "

RunningSession.create!(
  run_id: run1.id,
  date: Date.new(2024, 8, 26),
  program_id: program.id,
  status: "Uncompleted"
)

RunningSession.create!(
  run_id: run2.id,
  date: Date.new(2024, 8, 27),
  program_id: program.id,
  status: "Uncompleted"
)

RunningSession.create!(
  run_id: run3.id,
  date: Date.new(2024, 8, 29),
  program_id: program.id,
  status: "Uncompleted"
)

RunningSession.create!(
  run_id: run1.id,
  date: Date.new(2024, 8, 30),
  program_id: program.id,
  status: "Uncompleted"
)

RunningSession.create!(
  run_id: run2.id,
  date: Date.new(2024, 9, 1),
  program_id: program.id,
  status: "Uncompleted"
)

RunningSession.create!(
  run_id: run3.id,
  date: Date.new(2024, 9, 3),
  program_id: program.id,
  status: "Uncompleted"
)

puts "#{RunningSession.count} running sessions created ! "
