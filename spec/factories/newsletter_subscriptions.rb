# == Schema Information
#
# Table name: newsletter_subscriptions
#
#  id         :bigint           not null, primary key
#  email      :string           not null
#  subscribed :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_newsletter_subscriptions_on_email  (email) UNIQUE
#

FactoryBot.define do
  factory :newsletter_subscription, class: NewsletterSubscription.name do
    sequence(:email) { |n| "#{n}@foo.bar" }

    trait :unsubscribed do
      subscribed { false }
    end
  end
end
