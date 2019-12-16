# == Schema Information
#
# Table name: newsletter_subscriptions
#
#  id              :bigint           not null, primary key
#  date_subscribed :date             default(Mon, 16 Dec 2019), not null
#  email           :string           not null
#  subscribed      :boolean          default(TRUE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_newsletter_subscriptions_on_email  (email) UNIQUE
#

FactoryBot.define do
  factory :subscriber, class: NewsletterSubscription.name do
    email { 'test@test.com' }

    trait :unsubscribed do
      subscribed { false }
    end
  end
end
