# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  description :text             default(""), not null
#  name        :string           default(""), not null
#  status      :string           default("active"), not null
#  visibility  :string           default("public"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint
#  user_id     :bigint
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
    visibility { 'Public' }
    association :category, factory: :category
    association :user, factory: :user
  end

  trait :private do
    visibility { 'private' }
  end
end
