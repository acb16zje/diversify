# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id          :bigint           not null, primary key
#  description :text             default(""), not null
#  name        :string           default(""), not null
#  percentage  :integer          default(0), not null
#  priority    :enum             default("Medium"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  project_id  :bigint
#  skills_id   :bigint
#  user_id     :bigint
#  users_id    :bigint
#
# Indexes
#
#  index_tasks_on_project_id  (project_id)
#  index_tasks_on_skills_id   (skills_id)
#  index_tasks_on_user_id     (user_id)
#  index_tasks_on_users_id    (users_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (skills_id => skills.id)
#  fk_rails_...  (user_id => users.id)
#  fk_rails_...  (users_id => users.id)
#

class Task < ApplicationRecord

  enum priority: { High: 'high', Medium: 'medium', Low: 'low' }

  belongs_to :project
  belongs_to :user

  has_many :task_users, dependent: :destroy
  has_many :users, through: :task_users,
                   after_add: :send_assigned_notification,
                   after_remove: :send_removed_notification,
                   before_add: :check_in_project

  has_many :task_skills, dependent: :destroy
  has_many :skills, through: :task_skills

  validates :name, presence: true
  validates :priority, presence: true
  validates :percentage, presence: true, numericality: { only_integer: true },
                         inclusion: {
                           in: 0..100,
                           message: 'Percentage should be between 0 and 100'
                         }

  scope :user_data, lambda {
    joins(:users)
      .select('tasks.id, users.id as user_id, users.name as user_name')
      .group('tasks.id, users.id')
  }

  scope :data, lambda {
    joins(:user).left_joins(:skills)
                .select('tasks.id, tasks.description, tasks.name, tasks.user_id')
                .select('tasks.priority, tasks.percentage')
                .select('users.name as owner_name')
                .select("string_agg(skills.name, ',') as skill_names")
                .group('tasks.id, users.name')
  }

  def user_ids
    task_users.pluck(:user_id)
  end

  def completed?
    percentage == 100
  end

  after_update_commit :send_update_notification
  after_destroy_commit :destroy_notifications

  def send_picked_up_notification
    Notification.create(notification_params(user, 'task/picked'))
  end

  private

  def send_update_notification
    if saved_change_to_percentage? && completed?
      Notification.create(notification_params(user, 'task/completed'))
      users.each do |user|
        Activity.find_or_create_by(key: "task/#{id}", user: user, project: project)
      end
    else
      users.each do |user|
        Notification.create(notification_params(user, 'task/update'))
      end
    end
  end

  def send_assigned_notification(user)
    Notification.create(notification_params(user, 'task/assigned'))
  end

  def send_removed_notification(user)
    Notification.create(notification_params(user, 'task/removed'))
  end

  def destroy_notifications
    Notification.delete_by(notifier: self)
  end

  def notification_params(target, key)
    { user: target, key: key, notifiable: project, notifier: self }
  end

  def check_in_project(record)
    return if record.in_project?(project)

    errors[:base] << 'User is not in project'
    throw(:abort)
  end
end
