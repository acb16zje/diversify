# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

COMPABILITY_LIST = {
  INFP: [3, 3, 3, 4, 3, 4, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0],
  ENFP: [3, 3, 4, 3, 4, 3, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0],
  INFJ: [3, 4, 3, 3, 3, 3, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0],
  ENFJ: [4, 3, 3, 3, 3, 3, 3, 3, 4, 0, 0, 0, 0, 0, 0, 0],
  INTJ: [3, 4, 3, 3, 3, 3, 3, 4, 2, 2, 2, 2, 1, 1, 1, 1],
  ENTJ: [4, 3, 3, 3, 3, 3, 4, 3, 2, 2, 2, 2, 2, 2, 2, 2],
  INTP: [3, 3, 3, 3, 3, 4, 3, 3, 2, 2, 2, 2, 1, 1, 1, 4],
  ENTP: [3, 3, 4, 3, 4, 3, 3, 3, 2, 2, 2, 2, 1, 1, 1, 1],
  ISFP: [0, 0, 0, 4, 2, 2, 2, 2, 1, 1, 1, 1, 2, 4, 2, 4],
  ESFP: [0, 0, 0, 0, 2, 2, 2, 2, 1, 1, 1, 1, 4, 2, 4, 2],
  ISTP: [0, 0, 0, 0, 2, 2, 2, 2, 1, 1, 1, 1, 2, 4, 2, 4],
  ESTP: [0, 0, 0, 0, 2, 2, 2, 2, 1, 1, 1, 1, 4, 2, 4, 2],
  ISFJ: [0, 0, 0, 0, 1, 2, 1, 1, 2, 4, 2, 4, 3, 3, 3, 3],
  ESFJ: [0, 0, 0, 0, 1, 2, 1, 1, 4, 2, 4, 2, 3, 3, 3, 3],
  ISTJ: [0, 0, 0, 0, 1, 2, 1, 1, 2, 4, 2, 4, 3, 3, 3, 3],
  ESTJ: [0, 0, 0, 0, 1, 2, 4, 1, 4, 2, 4, 2, 3, 3, 3, 3]
}.freeze

# rubocop:disable Layout/LineLength
# 16 personalities
COMPABILITY_LIST.each do |key, value|
  Personality.find_or_create_by(
    mind: key[0], energy: key[1], nature: key[2], tactic: key[3],
    compabilities: value
  )
end

admin = User.find_or_create_by(name: 'Admin', email: 'admin@email.com', admin: true) do |u|
  u.password = 'password'
end

user = User.find_or_create_by(name: 'User', email: 'user@email.com', admin: false) do |u|
  u.password = 'password'
end

accounting = Category.find_or_create_by(name: 'Accounting and Finance')
construction = Category.find_or_create_by(name: 'Construction')
computing = Category.find_or_create_by(name: 'Computer and IT')

(1..6).each do |i|
  Project.find_or_create_by(
    name: "Project #{i}: #{Faker::Food.dish}",
    description: Faker::Food.description,
    status: %w[open active completed][i % 3 - 1],
    visibility: i.odd?,
    user: i.even? ? admin : user,
    category_id: (i - 1) % 3 + 1
  )
end

Skill.find_or_create_by(name: 'Budgeting', category: accounting)
Skill.find_or_create_by(name: 'Cash Flow Management', category: accounting)
Skill.find_or_create_by(name: 'Cost Reduction', category: accounting)
Skill.find_or_create_by(name: 'Tax Planning', category: accounting)

Skill.find_or_create_by(name: 'Bricklaying', category: construction)
Skill.find_or_create_by(name: 'Metal lathing', category: construction)
Skill.find_or_create_by(name: 'Plastering', category: construction)
Skill.find_or_create_by(name: 'Plumbing', category: construction)

Skill.find_or_create_by(name: 'Algorithms and Data Structures', category: computing)
Skill.find_or_create_by(name: 'Database Architecture', category: computing)
Skill.find_or_create_by(name: 'Kernel Programming', category: computing)
Skill.find_or_create_by(name: 'Web Development (Rails)', category: computing)
