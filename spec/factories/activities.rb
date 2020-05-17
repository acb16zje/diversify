# == Schema Information
#
# Table name: activities
#
#  id          :bigint           not null, primary key
#  key         :string           default("")
#  target_type :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  target_id   :bigint           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_activities_on_target_type_and_target_id  (target_type,target_id)
#  index_activities_on_user_id                    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :activity do
    
  end
end
