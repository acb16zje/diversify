# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 16 personalities
%w[I E].each do |mind|
  %w[S N].each do |energy|
    %w[T F].each do |nature|
      %w[J P].each do |tactic|
        Personality.create(mind: mind, energy: energy, nature: nature, tactic: tactic)
      end
    end
  end
end

admin = User.create(
  name: 'Admin',
  email: 'admin@email.com',
  password: 'password',
  admin: true
)

user = User.create(
  name: 'User',
  email: 'user@email.com',
  password: 'password',
  admin: false
)

Category.create(name: 'Accounting and Finance')
Category.create(name: 'Construction')
Category.create(name: 'Computer and IT')

(1..6).each do |i|
  Project.create(
    name: "Project #{i}: #{Faker::Food.dish}",
    description: Faker::Food.description,
    status: %w[open active completed][i % 3 - 1],
    visibility: i.odd?,
    user: i.even? ? admin : user,
    category_id: (i - 1) % 3 + 1
  )
end
