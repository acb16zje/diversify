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
  has_many :users, through: :collaborations, before_add: :check_users_limit,
                   after_add: :send_notification
  has_many :team_skills, dependent: :destroy
  has_many :skills, through: :team_skills

  validates :name,
            presence: true,
            uniqueness: { scope: :project_id, message: 'already exist' }
  validates :team_size,
            presence: true,
            numericality: { greater_than_or_equal_to: 1 }

  private

  def check_users_limit(_)
    project.check_users_limit

    return unless users.size > team_size

    errors[:base] << 'Team Size is smaller than total members'
  end

  def send_notification(user)
    Notification.create(
      { user: user, key: 'team', notifiable: project, notifier: self }
    )
  end
end
