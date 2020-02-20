# frozen_string_literal: true

# == Schema Information
#
# Table name: personalities
#
#  id         :bigint           not null, primary key
#  trait      :string           default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Personality model
class Personality < ApplicationRecord
  has_many :user_personalities
  has_many :users, through: :user_personalities

  NAME = {
    ISTJ: 'Logistician',
    INFJ: 'Advocate',
    INTJ: 'Architect',
    ENFJ: 'Protagonist',
    ISTP: 'Virtuoso',
    ESFJ: 'Consul',
    INFP: 'Mediator',
    ESFP: 'Entertainer',
    ENFP: 'Campaigner',
    ESTP: 'Entrepreneur',
    ESTJ: 'Executive',
    ENTJ: 'Commander',
    INTP: 'Logician',
    ISFJ: 'Defender',
    ENTP: 'Debater',
    ISFP: 'Adventurer'
  }.freeze

  def self.to_name(trait)
    NAME[trait.to_sym]
  end

  validates :trait, presence: true, uniqueness: true
end
