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

require 'rails_helper'

RSpec.describe SubscriptionPlan, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
