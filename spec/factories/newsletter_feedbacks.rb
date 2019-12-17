# frozen_string_literal: true

# == Schema Information
#
# Table name: newsletter_feedbacks
#
#  id         :bigint           not null, primary key
#  email      :string           default(""), not null
#  reason     :string           default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :newsletter_feedback, class: NewsletterFeedback.name do
    transient do
      no_longer { false }
      too_frequent { false }
      never_signed { false }
      inappropriate { false }
      not_interested { false }
    end

    email { 'test@test.com' }

    reason do
      "#{'no_longer ' if no_longer}
      #{'too_frequent ' if too_frequent}
      #{'never_signed ' if never_signed}
      #{'inappropriate ' if inappropriate}
      #{'not_interested' if not_interested}"
    end

    after(:build) do |newsletter_feedback, _|
      newsletter_feedback.reason.strip!
    end

  end
end
