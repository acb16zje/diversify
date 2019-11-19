# == Schema Information
#
# Table name: licenses
#
#  id              :bigint           not null, primary key
#  start_date      :date             not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  subscription_id :bigint
#  user_id         :bigint
#
# Indexes
#
#  index_licenses_on_subscription_id  (subscription_id)
#  index_licenses_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (subscription_id => subscriptions.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :license do
    
  end
end
