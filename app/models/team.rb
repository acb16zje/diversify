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

class Team < ApplicationRecord
  belongs_to :project

  # Join table
  has_many :collaborations, dependent: :destroy
  has_many :users, through: :collaborations

  validates :name,
            presence: true,
            uniqueness: { scope: :project_id, message: 'already exist' }
  validates :team_size,
            presence: true,
            numericality: { greater_than_or_equal_to: 1 }

  validate :user_limit

  private

  def user_limit
    return unless team_size < users.size

    errors[:base] << 'Team Size is smaller than total members'
  end
end
