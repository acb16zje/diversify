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

  validates :trait, presence: true, uniqueness: true
end
