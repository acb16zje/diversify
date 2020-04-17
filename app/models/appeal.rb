# frozen_string_literal: true

# == Schema Information
#
# Table name: appeals
#
#  id         :bigint           not null, primary key
#  type       :enum             default("invitation"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_appeals_on_project_id              (project_id)
#  index_appeals_on_user_id                 (user_id)
#  index_appeals_on_user_id_and_project_id  (user_id,project_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (user_id => users.id)
#
class Appeal < ApplicationRecord
  self.inheritance_column = nil

  enum type: { invitation: 'invitation', application: 'application' }

  belongs_to :project
  belongs_to :user

  validate :not_owner, on: :create
  validate :in_project, on: :create

  validates :user_id,
            presence: true,
            uniqueness: { scope: :project_id,
                          message: 'has already been invited/applied' }

  scope :list_in_project, lambda { |project|
    joins(:user)
      .select('appeals.id, users.id AS user_id, users.email AS user_email')
      .where(project: project)
  }

  after_create_commit :send_notification

  # resolution: accept or decline
  def send_resolve_notification(resolution, is_cancel = false)
    Notification.delete_by(send_notification_params)
    return if is_cancel

    Notification.create(
      user: invitation? ? project.user : user,
      key: "#{type}/#{resolution}",
      notifiable: invitation? ? user : project,
      notifier: project
    )
  end

  private

  def send_notification
    Notification.create(send_notification_params)
  end

  def send_notification_params
    {
      user: invitation? ? user : project.user,
      key: "#{type}/send",
      notifiable: invitation? ? project : user,
      notifier: project
    }
  end

  def not_owner
    errors[:base] << 'Owner cannot be added to project' if user == project&.user
  end

  def in_project
    errors[:base] << 'User already in project' if user&.in_project?(project)
  end
end
