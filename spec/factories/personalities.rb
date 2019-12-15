# == Schema Information
#
# Table name: personalities
#
#  id         :bigint           not null, primary key
#  trait      :string           default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :personality do

  end
end
