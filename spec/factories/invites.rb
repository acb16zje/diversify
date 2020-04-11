# == Schema Information
#
# Table name: invites
#
#  id         :bigint           not null, primary key
#  types      :enum             default("invite"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_invites_on_project_id              (project_id)
#  index_invites_on_user_id                 (user_id)
#  index_invites_on_user_id_and_project_id  (user_id,project_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :invite do
    types { 'invite' }
    association :project, factory: :project
    association :user, factory: :user
  end

  factory :application, parent: :invite do
    types { 'application' }
  end
end
