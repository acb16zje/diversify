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
#  index_licenses_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

# License model
class License < ApplicationRecord
  enum plan: { free: 'free', pro: 'pro', ultimate: 'ultimate' }

  belongs_to :user

  validates :plan, presence: true
  validates :user_id, presence: true, uniqueness: true
end
