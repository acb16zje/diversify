# frozen_string_literal: true

# == Schema Information
#
# Table name: licenses
#
#  id                   :bigint           not null, primary key
#  start_date           :date             not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  subscription_plan_id :bigint
#  user_id              :bigint
#
# Indexes
#
#  index_licenses_on_subscription_plan_id  (subscription_plan_id)
#  index_licenses_on_user_id               (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (subscription_plan_id => subscription_plans.id)
#  fk_rails_...  (user_id => users.id)
#

# License model
class License < ApplicationRecord
  belongs_to :user
  belongs_to :subscription_plan

  validates_presence_of :start_date
end
