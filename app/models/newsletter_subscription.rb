# == Schema Information
#
# Table name: newsletter_subscriptions
#
#  id              :bigint           not null, primary key
#  date_subscribed :date             not null
#  email           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class NewletterSubscription < ApplicationRecord
end
