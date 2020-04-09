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

    trait :isfp do
      mind { 'I' }
      energy { 'S' }
      nature { 'F' }
      tactic { 'P' }
    end

    trait :entp do
      mind { 'E' }
      energy { 'N' }
      nature { 'T' }
      tactic { 'P' }
    end

    trait :intp do
      mind { 'I' }
      energy { 'N' }
      nature { 'T' }
      tactic { 'P' }
    end

    trait :entj do
      mind { 'E' }
      energy { 'N' }
      nature { 'T' }
      tactic { 'J' }
    end

    trait :estj do
      mind { 'E' }
      energy { 'S' }
      nature { 'T' }
      tactic { 'J' }
    end

    trait :estp do
      mind { 'E' }
      energy { 'S' }
      nature { 'T' }
      tactic { 'P' }
    end

    trait :enfp do
      mind { 'E' }
      energy { 'N' }
      nature { 'F' }
      tactic { 'P' }
    end

    trait :esfp do
      mind { 'E' }
      energy { 'S' }
      nature { 'F' }
      tactic { 'P' }
    end

    trait :infp do
      mind { 'I' }
      energy { 'N' }
      nature { 'F' }
      tactic { 'P' }
    end

    trait :esfj do
      mind { 'E' }
      energy { 'S' }
      nature { 'F' }
      tactic { 'J' }
    end

    trait :istp do
      mind { 'I' }
      energy { 'S' }
      nature { 'T' }
      tactic { 'P' }
    end

    trait :enfj do
      mind { 'E' }
      energy { 'N' }
      nature { 'F' }
      tactic { 'J' }
    end

    trait :isfj do
      mind { 'I' }
      energy { 'S' }
      nature { 'F' }
      tactic { 'J' }
    end

    trait :infj do
      mind { 'I' }
      energy { 'N' }
      nature { 'F' }
      tactic { 'J' }
    end

    trait :istj do
      mind { 'I' }
      energy { 'S' }
      nature { 'T' }
      tactic { 'J' }
    end
  end
end
