# frozen_string_literal: true

# == Schema Information
#
# Table name: skills
#
#  id          :bigint           not null, primary key
#  description :text             default(""), not null
#  name        :string           default(""), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint
#
# Indexes
#
#  index_skills_on_category_id  (category_id)
#  index_skills_on_name         (name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#

class Skill < ApplicationRecord
  belongs_to :category
  has_many :task_skills, dependent: :destroy
  has_many :tasks, through: :team_skills
  has_many :skill_levels, dependent: :destroy
  has_many :team_skills, dependent: :destroy
  has_many :teams, through: :team_skills

  validates :description, presence: true
  validates :name, presence: true, uniqueness: true
end
