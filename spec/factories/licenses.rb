# == Schema Information
#
# Table name: licenses
#
#  id         :bigint           not null, primary key
#  plan       :enum             default("free"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_licenses_on_user_id  (user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :license do
    
  end
end
