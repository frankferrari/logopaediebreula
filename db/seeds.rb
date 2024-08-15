# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require_relative '../app/models/shared/location'
require_relative '../app/models/shared/language'
require_relative '../app/models/shared/focusarea'

# Clear existing data
puts "Clearing existing data..."
Shared::Location.destroy_all
Shared::Language.destroy_all
Shared::Focusarea.destroy_all

# Seed Locations
puts "Seeding Locations..."
locations = ["Corinthstraße", "Sonntagstraße"]
locations.each do |name|
  Shared::Location.create!(name: name)
end
puts "Created #{Shared::Location.count} locations"

# Seed Languages
puts "Seeding Languages..."
languages = ["Deutsch", "Englisch", "Tschechisch", "Niederländisch"]
languages.each do |name|
  Shared::Language.create!(name: name)
end
puts "Created #{Shared::Language.count} languages"

# Seed Focus Area
puts "Seeding Focus Area..."
focusareas = [
  "Aussprachestörung",
  "Autismus",
  "Essverhaltensstörung",
  "Fütterstörung",
  "Myofunktionelle Störung",
  "Orale Restriktion",
  "Poltern",
  "Selektiver Mutismus",
  "Sprachentwicklungsstörungen",
  "Stimmstörungen",
  "Stimmtraining bei Trans*",
  "Stottern",
  "Unterstützte Kommunikation",
  "neurologische Störung"
]
focusareas.each do |name|
  Shared::Focusarea.create!(name: name)
end
puts "Created #{Shared::Focusarea.count} areas of focus"

puts "Seeding completed successfully!"