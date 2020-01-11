# frozen_string_literal: true

# == Schema Information
#
# Table name: newsletter_feedbacks
#
#  id                         :bigint           not null, primary key
#  reasons                    :string           default([]), not null, is an Array
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  newsletter_subscription_id :bigint
#
# Indexes
#
#  index_newsletter_feedbacks_on_newsletter_subscription_id  (newsletter_subscription_id)
#
# Foreign Keys
#
#  fk_rails_...  (newsletter_subscription_id => newsletter_subscriptions.id)
#

FactoryBot.define do
  factory :newsletter_feedback, class: NewsletterFeedback.name do
    subscribed

    trait :subscribed do
      newsletter_subscription
    end

    trait :not_subscribed do
      association :newsletter_subscription, :unsubscribed
    end

    trait :no_longer do
      after(:build) do |newsletter_feedback|
        newsletter_feedback.reasons ||= []
        newsletter_feedback.reasons << 'no_longer'
      end
    end

    trait :too_frequent do
      after(:build) do |newsletter_feedback|
        newsletter_feedback.reasons ||= []
        newsletter_feedback.reasons << 'too_frequent'
      end
    end

    trait :never_signed do
      after(:build) do |newsletter_feedback|
        newsletter_feedback.reasons ||= []
        newsletter_feedback.reasons << 'never_signed'
      end
    end

    trait :inappropriate do
      after(:build) do |newsletter_feedback|
        newsletter_feedback.reasons ||= []
        newsletter_feedback.reasons << 'inappropriate'
      end
    end

    trait :not_interested do
      after(:build) do |newsletter_feedback|
        newsletter_feedback.reasons ||= []
        newsletter_feedback.reasons << 'not_interested'
      end
    end
  end
end
