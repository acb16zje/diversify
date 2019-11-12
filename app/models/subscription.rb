# == Schema Information
#
# Table name: subscriptions
#
#  id           :bigint           not null, primary key
#  monthly_cost :float            not null
#  start_date   :date             not null
#  subscription :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint
#
# Indexes
#
#  index_subscriptions_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class Subscription < ApplicationRecord
    belongs_to :user

    validates_presence_of :start_date, :monthly_cost, :subscription
end
