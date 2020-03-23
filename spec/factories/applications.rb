# == Schema Information
#
# Table name: applications
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
#  index_applications_on_project_id  (project_id)
#  index_applications_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :application do
    association :project, factory: :project
    association :user, factory: :user
  end
end
