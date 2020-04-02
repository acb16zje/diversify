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
# Indexes
#
#  index_personalities_on_mind_and_energy_and_nature_and_tactic  (mind,energy,nature,tactic) UNIQUE
#

FactoryBot.define do
  factory :personality do
    intj

    trait :intj do
      mind { 'I' }
      energy { 'N' }
      nature { 'T' }
      tactic { 'J' }
    end
  end
end
