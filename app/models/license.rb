# frozen_string_literal: true

# == Schema Information
#
# Table name: licenses
#
#  id         :bigint           not null, primary key
#  plan       :enum             default("free"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_licenses_on_user_id  (user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class License < ApplicationRecord
  enum plan: { free: 'free', pro: 'pro', ultimate: 'ultimate' }
  MEMBER_LIMIT = { free: 10, pro: 30, ultimate: 1 / 0.0 }.freeze

  belongs_to :user

  validates :plan, presence: true
  validates :user_id, presence: true, uniqueness: true

  def member_limit
    MEMBER_LIMIT[plan.to_sym]
  end
end
