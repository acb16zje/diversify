# frozen_string_literal: true

require 'faker'

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
        Personality.find_or_create_by(mind: mind, energy: energy, nature: nature, tactic: tactic)
      end
    end
  end
end

admin = User.create_with(
  email: 'admin@email.com',
  password: 'password',
  admin: true
).find_or_create_by(name: 'Admin')

user = User.create_with(
  email: 'user@email.com',
  password: 'password',
  admin: false
).find_or_create_by(name: 'User')

Category.find_or_create_by(name: 'Accounting and Finance')
Category.find_or_create_by(name: 'Construction')
Category.find_or_create_by(name: 'Computer and IT')

(1..6).each do |i|
  Project.create_with(
    name: "Project #{i}: #{Faker::Food.dish}",
    description: Faker::Food.description,
    status: %w[open active completed][i % 3 - 1],
    visibility: i.odd?,
    user: i.even? ? admin : user,
    category_id: (i - 1) % 3 + 1
  ).find_or_create_by(id: i)
end

(0..5).each do |i|
  Skill.create_with(
    name: "Skill #{Faker::Food.dish}",
    description: Faker::Food.description,
    category_id: i % 3
  ).find_or_create_by(id: i)
end
