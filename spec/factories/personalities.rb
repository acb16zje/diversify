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
      id { 5 }
      mind { 'I' }
      energy { 'N' }
      nature { 'T' }
      tactic { 'J' }
      compatibilities { [1, 2, 1, 1, 1, 1, 1, 2, 0, 0, 0, 0, -1, -1, -1, 1] }
    end

    trait :isfp do
      id { 9 }
      mind { 'I' }
      energy { 'S' }
      nature { 'F' }
      tactic { 'P' }
      compatibilities { [-2, -2, -2, 2, 0, 0, 0, 0, -1, -1, -1, -1, 0, 2, 0, 2] }
    end

    trait :entp do
      mind { 'E' }
      energy { 'N' }
      nature { 'T' }
      tactic { 'P' }
      compatibilities { [1, 1, 2, 1, 2, 1, 1, 1, 0, 0, 0, 0, -1, -1, -1, 1] }
    end

    trait :intp do
      mind { 'I' }
      energy { 'N' }
      nature { 'T' }
      tactic { 'P' }
      compatibilities { [1, 1, 1, 1, 1, 2, 1, 1, 0, 0, 0, 0, -1, -1, -1, 2] }
    end

    trait :entj do
      mind { 'E' }
      energy { 'N' }
      nature { 'T' }
      tactic { 'J' }
      compatibilities { [2, 1, 1, 1, 1, 1, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0] }
    end

    trait :estj do
      mind { 'E' }
      energy { 'S' }
      nature { 'T' }
      tactic { 'J' }
      compatibilities { [-2, -2, -2, -2, -1, 0, 2, -1, 2, 0, 2, 0, 1, 1, 1, 1] }
    end

    trait :estp do
      mind { 'E' }
      energy { 'S' }
      nature { 'T' }
      tactic { 'P' }
      compatibilities { [-2, -2, -2, -2, 0, 0, 0, 0, -1, -1, -1, -1, 2, 0, 2, 0] }
    end

    trait :enfp do
      id { 2 }
      mind { 'E' }
      energy { 'N' }
      nature { 'F' }
      tactic { 'P' }
      compatibilities { [1, 1, 2, 1, 2, 1, 1, 1, -2, -2, -2, -2, -2, -2, -2, -2] }
    end

    trait :esfp do
      mind { 'E' }
      energy { 'S' }
      nature { 'F' }
      tactic { 'P' }
      compatibilities { [-2, -2, -2, -2, 0, 0, 0, 0, -1, -1, -1, -1, 2, 0, 2, 0] }
    end

    trait :infp do
      id { 1 }
      mind { 'I' }
      energy { 'N' }
      nature { 'F' }
      tactic { 'P' }
      compatibilities { [1, 1, 1, 2, 1, 2, 1, 1, -2, -2, -2, -2, -2, -2, -2, -2] }
    end

    trait :esfj do
      mind { 'E' }
      energy { 'S' }
      nature { 'F' }
      tactic { 'J' }
      compatibilities { [-2, -2, -2, -2, -1, 0, -1, -1, 2, 0, 2, 0, 1, 1, 1, 1] }
    end

    trait :istp do
      mind { 'I' }
      energy { 'S' }
      nature { 'T' }
      tactic { 'P' }
      compatibilities { [-2, -2, -2, -2, 0, 0, 0, 0, -1, -1, -1, -1, 0, 2, 0, 2] }
    end

    trait :enfj do
      mind { 'E' }
      energy { 'N' }
      nature { 'F' }
      tactic { 'J' }
      compatibilities { [2, 1, 1, 1, 1, 1, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0] }
    end

    trait :isfj do
      mind { 'I' }
      energy { 'S' }
      nature { 'F' }
      tactic { 'J' }
      compatibilities { [-2, -2, -2, -2, -1, 0, -1, -1, 0, 2, 0, 2, 1, 1, 1, 1] }
    end

    trait :infj do
      mind { 'I' }
      energy { 'N' }
      nature { 'F' }
      tactic { 'J' }
      compatibilities { [1, 2, 1, 1, 1, 1, 1, 2, -2, -2, -2, -2, -2, -2, -2, -2] }
    end

    trait :istj do
      mind { 'I' }
      energy { 'S' }
      nature { 'T' }
      tactic { 'J' }
      compatibilities { [-2, -2, -2, -2, -1, 0, -1, -1, 0, 2, 0, 2, 1, 1, 1, 1] }
    end
  end
end
