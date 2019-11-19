# == Schema Information
#
# Table name: newletter_subscriptions
#
#  id              :bigint           not null, primary key
#  date_subscribed :date             not null
#  email           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe NewletterSubscription, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
