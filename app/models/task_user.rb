# frozen_string_literal: true

# == Schema Information
#
# Table name: task_users
#
#  id         :bigint           not null, primary key
#  owner      :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  task_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_task_users_on_task_id              (task_id)
#  index_task_users_on_user_id              (user_id)
#  index_task_users_on_user_id_and_task_id  (user_id,task_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (task_id => tasks.id)
#
class TaskUser < ApplicationRecord
  belongs_to :task
  belongs_to :user

  validates :user_id, presence: true, uniqueness: { scope: :task_id }
  validates :task_id, presence: true
end
