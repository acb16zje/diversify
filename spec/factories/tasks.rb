# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id          :bigint           not null, primary key
#  description :text             default(""), not null
#  name        :string           default(""), not null
#  percentage  :integer          default(0), not null
#  priority    :enum             default("medium"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  project_id  :bigint
#  user_id     :bigint
#
# Indexes
#
#  index_tasks_on_project_id  (project_id)
#  index_tasks_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :task do
    name { generate(:name) }
    description { 'test' }
    percentage { 0 }
    priority { 'medium' }
    association :user, factory: :user
    association :project, factory: :project

    trait :completed do
      percentage { 100 }
    end
  end
end
