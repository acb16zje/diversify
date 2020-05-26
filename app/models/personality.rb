# frozen_string_literal: true

# == Schema Information
#
# Table name: personalities
#
#  id              :bigint           not null, primary key
#  compatibilities :integer          default([]), is an Array
#  energy          :enum
#  mind            :enum
#  nature          :enum
#  tactic          :enum
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_personalities_on_mind_and_energy_and_nature_and_tactic  (mind,energy,nature,tactic) UNIQUE
#

class Personality < ApplicationRecord
  TYPES = {
    INTJ: 'Architect',
    INTP: 'Logician',
    ENTJ: 'Commander',
    ENTP: 'Debater',
    INFJ: 'Advocate',
    INFP: 'Mediator',
    ENFJ: 'Protagonist',
    ENFP: 'Campaigner',
    ISTJ: 'Logistician',
    ISFJ: 'Defender',
    ESTJ: 'Executive',
    ESFJ: 'Consul',
    ISTP: 'Virtuoso',
    ISFP: 'Adventurer',
    ESTP: 'Entrepreneur',
    ESFP: 'Entertainer'
  }.freeze

  has_many :users, dependent: :nullify

  validates :mind, presence: true, inclusion: { in: %w[I E] }
  validates :energy, presence: true, inclusion: { in: %w[S N] }
  validates :nature, presence: true, inclusion: { in: %w[T F] }
  validates :tactic, presence: true, inclusion: { in: %w[J P] }

  def to_type
    TYPES[trait.to_sym]
  end

  def trait
    mind + energy + nature + tactic
  end
end
