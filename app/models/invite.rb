# frozen_string_literal: true

# == Schema Information
#
# Table name: invites
#
#  id         :bigint           not null, primary key
#  types      :enum             default("Invite"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_invites_on_project_id  (project_id)
#  index_invites_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (user_id => users.id)
#
class Invite < ApplicationRecord
  belongs_to :project
  belongs_to :user
  validates :user_id, uniqueness: {
    scope: :project_id,
    message: 'has already been invited/applied'
  }

  after_commit :send_notification, on: :create

  acts_as_notifiable :users,
                     targets: lambda { |invite, key|
                       if key == 'invite.invite'
                         [invite.user]
                       elsif key == 'invite.application'
                         [invite.project.user]
                       end
                     },
                     notifiable_path: :project_notifiable_path

  private

  def project_notifiable_path
    project_path(project)
  end

  def send_notification
    notify :user, key: "invite.#{types.downcase}", notifier: project
  end
end
