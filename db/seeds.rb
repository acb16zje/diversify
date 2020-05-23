# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

COMPABILITY_LIST = {
  INFP: [1, 1, 1, 2, 1, 2, 1, 1, -2, -2, -2, -2, -2, -2, -2, -2],
  ENFP: [1, 1, 2, 1, 2, 1, 1, 1, -2, -2, -2, -2, -2, -2, -2, -2],
  INFJ: [1, 2, 1, 1, 1, 1, 1, 2, -2, -2, -2, -2, -2, -2, -2, -2],
  ENFJ: [2, 1, 1, 1, 1, 1, 1, 1, 2, -2, -2, -2, -2, -2, -2, -2],
  INTJ: [1, 2, 1, 1, 1, 1, 1, 2, 0, 0, 0, 0, -1, -1, -1, 1],
  ENTJ: [2, 1, 1, 1, 1, 1, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0],
  INTP: [1, 1, 1, 1, 1, 2, 1, 1, 0, 0, 0, 0, -1, -1, -1, 2],
  ENTP: [1, 1, 2, 1, 2, 1, 1, 1, 0, 0, 0, 0, -1, -1, -1, 1],
  ISFP: [-2, -2, -2, 2, 0, 0, 0, 0, -1, -1, -1, -1, 0, 2, 0, 2],
  ESFP: [-2, -2, -2, -2, 0, 0, 0, 0, -1, -1, -1, -1, 2, 0, 2, 0],
  ISTP: [-2, -2, -2, -2, 0, 0, 0, 0, -1, -1, -1, -1, 0, 2, 0, 2],
  ESTP: [-2, -2, -2, -2, 0, 0, 0, 0, -1, -1, -1, -1, 2, 0, 2, 0],
  ISFJ: [-2, -2, -2, -2, -1, 0, -1, -1, 0, 2, 0, 2, 1, 1, 1, 1],
  ESFJ: [-2, -2, -2, -2, -1, 0, -1, -1, 2, 0, 2, 0, 1, 1, 1, 1],
  ISTJ: [-2, -2, -2, -2, -1, 0, -1, -1, 0, 2, 0, 2, 1, 1, 1, 1],
  ESTJ: [-2, -2, -2, -2, -1, 0, 2, -1, 2, 0, 2, 0, 1, 1, 1, 1]
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

(1..100).each do |i|
  dummy = User.find_or_create_by(name: "User#{i}", email: "user#{i}@email.com", admin: false) do |u|
    u.password = 'password'
    u.personality_id = (i % 16) + 1
  end
  UserSkill.find_or_create_by(user: dummy, skill_id: (i % 4) + 1)
  Collaboration.find_or_create_by(user: dummy, team_id: 1)
end

license = License.where(user: user)
license.update(plan: 'ultimate')

# rubocop:enable Layout/LineLength
