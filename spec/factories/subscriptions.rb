# == Schema Information
#
# Table name: subscriptions
#
#  id           :bigint           not null, primary key
#  monthly_cost :float            not null
#  subscription :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryBot.define do
  factory :subscription do

  end
end
