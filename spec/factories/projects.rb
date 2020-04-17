# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  description :text             default(""), not null
#  name        :string(100)      default(""), not null
#  status      :enum             default("active"), not null
#  visibility  :boolean          default(TRUE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint
#  user_id     :bigint           not null
#
# Indexes
#
#  index_projects_on_category_id  (category_id)
#  index_projects_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :project do
    description { 'lorem ipsum' }
    name { 'Project' }

    association :category, factory: :category
    association :user, factory: :user

    trait :open do
      status { 'open' }
    end

    trait :completed do
      status { 'completed' }
    end

    trait :private do
      visibility { false }
    end

    trait :with_avatar do
      avatar { Rack::Test::UploadedFile.new('spec/fixtures/squirtle.png') }
    end
  end

  factory :project_with_members, parent: :project do
    transient do
      members_count { 5 }
    end

    after(:create) do |project, evaluator|
      project.unassigned_team.users << build_list(:user, evaluator.members_count)
    end
  end
end
