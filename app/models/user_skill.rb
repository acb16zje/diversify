# frozen_string_literal: true

class UserSkill < ApplicationRecord
  belongs_to :user
  belongs_to :skill

  validates :skill_id, presence: true, uniqueness: { scope: :user_id }
  validates :user_id, presence: true
end
