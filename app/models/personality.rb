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

  def to_name
    NAME[trait.to_sym]
  end

  def trait
    (mind + energy + nature + tactic).upcase
  end

  validates :mind, presence: true
  validates :energy, presence: true
  validates :nature, presence: true
  validates :tactic, presence: true
end
