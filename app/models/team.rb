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
#  project_id :bigint
#
# Indexes
#
#  index_teams_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#

class Team < ApplicationRecord
  belongs_to :project
  # has_many :teams_user
  has_and_belongs_to_many :users

  validates :name, presence: true
  validates :team_size,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }
  validates :name, uniqueness: {
    scope: :project_id,
    message: 'already Exist'
  }

end
