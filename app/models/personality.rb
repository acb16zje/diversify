# frozen_string_literal: true

# == Schema Information
#
# Table name: personalities
#
#  id             :bigint           not null, primary key
#  trait          :string           default(""), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  compatibles_id :bigint
#
# Indexes
#
#  index_personalities_on_compatibles_id  (compatibles_id)
#
# Foreign Keys
#
#  fk_rails_...  (compatibles_id => personalities.id)
#

# Personality model
class Personality < ApplicationRecord
  has_many :user_personalities
  has_many :users, through: :user_personalities

  validates :trait, presence: true, uniqueness: true
end
