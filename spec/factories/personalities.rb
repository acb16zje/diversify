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

  trait :isfp do
    mind { 'i' }
    energy { 's' }
    nature { 'f' }
    tactic { 'p' }
  end

  trait :entp do
    mind { 'e' }
    energy { 'n' }
    nature { 't' }
    tactic { 'p' }
  end

  trait :intp do
    mind { 'i' }
    energy { 'n' }
    nature { 't' }
    tactic { 'p' }
  end

  trait :entj do
    mind { 'e' }
    energy { 'n' }
    nature { 't' }
    tactic { 'j' }
  end

  trait :estj do
    mind { 'e' }
    energy { 's' }
    nature { 't' }
    tactic { 'j' }
  end

  trait :estp do
    mind { 'e' }
    energy { 's' }
    nature { 't' }
    tactic { 'p' }
  end

  trait :enfp do
    mind { 'e' }
    energy { 'n' }
    nature { 'f' }
    tactic { 'p' }
  end

  trait :esfp do
    mind { 'e' }
    energy { 's' }
    nature { 'f' }
    tactic { 'p' }
  end

  trait :infp do
    mind { 'i' }
    energy { 'n' }
    nature { 'f' }
    tactic { 'p' }
  end

  trait :esfj do
    mind { 'e' }
    energy { 's' }
    nature { 'f' }
    tactic { 'j' }
  end

  trait :istp do
    mind { 'i' }
    energy { 's' }
    nature { 't' }
    tactic { 'p' }
  end

  trait :enfj do
    mind { 'e' }
    energy { 'n' }
    nature { 'f' }
    tactic { 'j' }
  end

  trait :intj do
    mind { 'i' }
    energy { 'n' }
    nature { 't' }
    tactic { 'j' }
  end

  trait :infj do
    mind { 'i' }
    energy { 'n' }
    nature { 'f' }
    tactic { 'j' }
  end

  trait :istj do
    mind { 'i' }
    energy { 's' }
    nature { 't' }
    tactic { 'j' }
  end
end
