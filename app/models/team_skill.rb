# frozen_string_literal: true

class TeamSkill < ApplicationRecord
  belongs_to :team
  belongs_to :skill

  validates :skill_id, presence: true, uniqueness: { scope: :team_id }
  validates :team_id, presence: true
end
