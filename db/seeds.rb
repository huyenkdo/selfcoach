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

Session.delete_all
Run.delete_all
Program.delete_all
User.delete_all

User.create(
  email: "exemple1@email.com",
  password: "12345",
  first_name: "Paul",
  weight: 80,
  age: 25,
  vma: 12
)

Program.create(
  objective_km: 42.195,
  objective_time: 195,
  race_date: Date.new(2025, 4, 13),
  free_days:
)
