# frozen_string_literal: true

# == Schema Information
#
# Table name: teams
#
#  id         :bigint           not null, primary key
#  name       :string           default(""), not null
#  team_size  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :bigint           not null
#
# Indexes
#
#  index_teams_on_name_and_project_id  (name,project_id) UNIQUE
#  index_teams_on_project_id           (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#

FactoryBot.define do
  factory :team do
    name { generate(:name) }
    team_size { 5 }
    association :project, factory: :project
  end

  trait :with_skill do
    association :skills, factory: :skill
  end
end
