# frozen_string_literal: true

# == Schema Information
#
# Table name: subscription_plans
#
#  id           :bigint           not null, primary key
#  monthly_cost :float            not null
#  name         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_subscription_plans_on_name  (name) UNIQUE
#

# Subscription model
class SubscriptionPlan < ApplicationRecord
  has_many :licenses

  validates_presence_of :monthly_cost, :name
end
