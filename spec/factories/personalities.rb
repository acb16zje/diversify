# frozen_string_literal: true

# == Schema Information
#
# Table name: personalities
#
#  id         :bigint           not null, primary key
#  energy     :enum
#  mind       :enum
#  nature     :enum
#  tactic     :enum
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :personality do
    mind { 'i' }
    energy { 's' }
    nature { 'f' }
    tactic { 'j' }
  end
end
