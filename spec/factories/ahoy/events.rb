# frozen_string_literal: true

# == Schema Information
#
# Table name: ahoy_events
#
#  id         :bigint           not null, primary key
#  name       :string
#  properties :jsonb
#  time       :datetime
#  user_id    :bigint
#  visit_id   :bigint
#
# Indexes
#
#  index_ahoy_events_on_name_and_time  (name,time)
#  index_ahoy_events_on_properties     (properties) USING gin
#  index_ahoy_events_on_user_id        (user_id)
#  index_ahoy_events_on_visit_id       (visit_id)
#

FactoryBot.define do
  factory :ahoy_event, class: Ahoy::Event.name do
    association :visit, factory: :ahoy_visit

    trait :ran_action do
      name { 'Ran action' }
    end

    trait :time_spent do
      name { 'Time Spent' }
    end

    # Pricing subscriptions traits
    trait :pricing_link do
      name { 'Clicked pricing link' }
    end

    trait :free do
      pricing_link
      properties { { type: 'Free' } }
    end

    trait :pro do
      pricing_link
      properties { { type: 'Pro' } }
    end

    trait :enterprise do
      pricing_link
      properties { { type: 'Enterprise' } }
    end

    # Social share traits
    trait :social_share do
      name { 'Click Social' }
    end

    trait :facebook do
      social_share
      properties { { type: 'Facebook' } }
    end

    trait :twitter do
      social_share
      properties { { type: 'Twitter' } }
    end

    trait :email do
      social_share
      properties { { type: 'Email' } }
    end

    time { Time.zone.now }
  end
end
