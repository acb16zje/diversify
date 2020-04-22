# frozen_string_literal: true

# == Schema Information
#
# Table name: skills
#
#  id          :bigint           not null, primary key
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
  has_many :tasks, through: :task_skills
  has_many :team_skills, dependent: :destroy
  has_many :teams, through: :team_skills

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
