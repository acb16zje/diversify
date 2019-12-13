# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id          :bigint           not null, primary key
#  description :text             default(""), not null
#  experience  :integer          default(0), not null
#  name        :string           default(""), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  project_id  :bigint
#  skills_id   :bigint
#  user_id     :bigint
#
# Indexes
#
#  index_tasks_on_project_id  (project_id)
#  index_tasks_on_skills_id   (skills_id)
#  index_tasks_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (skills_id => skills.id)
#  fk_rails_...  (user_id => users.id)
#

# Task model
class Task < ApplicationRecord
  belongs_to :project
  has_one :user
  has_many :skills

  validates_presence_of :name, :experience
  validates :experience, numericality: { greater_than: 0 }
end
