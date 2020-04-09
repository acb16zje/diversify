# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  description :text             default(""), not null
#  name        :string           default(""), not null
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
    status { 'active' }
    association :category, factory: :category
    association :user, factory: :user

    trait :with_avatar do
      avatar { Rack::Test::UploadedFile.new('spec/fixtures/squirtle.png') }
    end

    trait :private do
      visibility { false }
    end
  end
end
