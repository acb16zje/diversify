# frozen_string_literal: true

# == Schema Information
#
# Table name: task_skills
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  skill_id   :bigint           not null
#  task_id    :bigint           not null
#
# Indexes
#
#  index_task_skills_on_skill_id              (skill_id)
#  index_task_skills_on_skill_id_and_task_id  (skill_id,task_id) UNIQUE
#  index_task_skills_on_task_id               (task_id)
#
# Foreign Keys
#
#  fk_rails_...  (skill_id => skills.id)
#  fk_rails_...  (task_id => tasks.id)
#
class TaskSkill < ApplicationRecord
  belongs_to :task
  belongs_to :skill

  validates :skill_id, presence: true, uniqueness: { scope: :task_id }
  validates :task_id, presence: true
end
