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
# Indexes
#
#  index_newsletter_subscriptions_on_email  (email) UNIQUE
#

FactoryBot.define do
  factory :subscriber, class: 'NewsletterSubscription' do
    email { 'test@test.com' }
    date_subscribed { Time.now }
  end
end
