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
      id { 8 }
      mind { 'E' }
      energy { 'N' }
      nature { 'T' }
      tactic { 'P' }
      compatibilities { [1, 1, 2, 1, 2, 1, 1, 1, 0, 0, 0, 0, -1, -1, -1, 1] }
    end

    trait :intp do
      id { 7 }
      mind { 'I' }
      energy { 'N' }
      nature { 'T' }
      tactic { 'P' }
      compatibilities { [1, 1, 1, 1, 1, 2, 1, 1, 0, 0, 0, 0, -1, -1, -1, 2] }
    end

    trait :entj do
      id { 6 }
      mind { 'E' }
      energy { 'N' }
      nature { 'T' }
      tactic { 'J' }
      compatibilities { [2, 1, 1, 1, 1, 1, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0] }
    end

    trait :estj do
      id { 16 }
      mind { 'E' }
      energy { 'S' }
      nature { 'T' }
      tactic { 'J' }
      compatibilities { [-2, -2, -2, -2, -1, 0, 2, -1, 2, 0, 2, 0, 1, 1, 1, 1] }
    end

    trait :estp do
      id { 12 }
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
      id { 10 }
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
      id { 14 }
      mind { 'E' }
      energy { 'S' }
      nature { 'F' }
      tactic { 'J' }
      compatibilities { [-2, -2, -2, -2, -1, 0, -1, -1, 2, 0, 2, 0, 1, 1, 1, 1] }
    end

    trait :istp do
      id { 11 }
      mind { 'I' }
      energy { 'S' }
      nature { 'T' }
      tactic { 'P' }
      compatibilities { [-2, -2, -2, -2, 0, 0, 0, 0, -1, -1, -1, -1, 0, 2, 0, 2] }
    end

    trait :enfj do
      id { 4 }
      mind { 'E' }
      energy { 'N' }
      nature { 'F' }
      tactic { 'J' }
      compatibilities { [2, 1, 1, 1, 1, 1, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0] }
    end

    trait :isfj do
      id { 13 }
      mind { 'I' }
      energy { 'S' }
      nature { 'F' }
      tactic { 'J' }
      compatibilities { [-2, -2, -2, -2, -1, 0, -1, -1, 0, 2, 0, 2, 1, 1, 1, 1] }
    end

    trait :infj do
      id { 3 }
      mind { 'I' }
      energy { 'N' }
      nature { 'F' }
      tactic { 'J' }
      compatibilities { [1, 2, 1, 1, 1, 1, 1, 2, -2, -2, -2, -2, -2, -2, -2, -2] }
    end

    trait :istj do
      id { 15 }
      mind { 'I' }
      energy { 'S' }
      nature { 'T' }
      tactic { 'J' }
      compatibilities { [-2, -2, -2, -2, -1, 0, -1, -1, 0, 2, 0, 2, 1, 1, 1, 1] }
    end
  end
end
