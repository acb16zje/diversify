# == Schema Information
#
# Table name: preferences
#
#  id              :bigint           not null, primary key
#  group_size      :integer          default(0), not null
#  preferred_tasks :text             default(""), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :bigint
#
# Indexes
#
#  index_preferences_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :preference do

  end
end
