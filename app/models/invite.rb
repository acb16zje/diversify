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

  acts_as_notifiable :users,
                     targets: ->(invite, key) { [invite.user] },
                     notifiable_path: :project_notifiable_path

  def project_notifiable_path
    project_path(invite.project)
  end
end
