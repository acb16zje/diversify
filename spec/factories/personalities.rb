# == Schema Information
#
# Table name: personalities
#
#  id             :bigint           not null, primary key
#  trait          :string           default(""), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  compatibles_id :bigint
#
# Indexes
#
#  index_personalities_on_compatibles_id  (compatibles_id)
#
# Foreign Keys
#
#  fk_rails_...  (compatibles_id => personalities.id)
#

FactoryBot.define do
  factory :personality do
    
  end
end
