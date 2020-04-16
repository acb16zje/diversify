# frozen_string_literal: true

# == Schema Information
#
# Table name: team_skills
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  skill_id   :bigint           not null
#  team_id    :bigint           not null
#
# Indexes
#
#  index_team_skills_on_skill_id              (skill_id)
#  index_team_skills_on_skill_id_and_team_id  (skill_id,team_id) UNIQUE
#  index_team_skills_on_team_id               (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (skill_id => skills.id)
#  fk_rails_...  (team_id => teams.id)
#
FactoryBot.define do
  factory :team_skill do
    association :skill, factory: :skill
    association :team, factory: :team
  end
end
