# frozen_string_literal: true

# == Schema Information
#
# Table name: landing_feedbacks
#
#  id         :bigint           not null, primary key
#  channel    :string           default(""), not null
#  interest   :boolean          default(TRUE)
#  smiley     :string           default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :landing_feedback, class: LandingFeedback.name do
    smiley { 'neutral' }
    interest { true }
    channel { 'Social Media' }

    trait :yesterday do
      created_at { Time.now - 1.days }
    end
  end
end
