# frozen_string_literal: true

# == Schema Information
#
# Table name: newsletter_feedbacks
#
#  id         :bigint           not null, primary key
#  email      :string           default(""), not null
#  reasons    :string           default([]), not null, is an Array
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# NewsletterFeedback model
class NewsletterFeedback < ApplicationRecord
  include DateScope

  REASONS = { no_longer: 'I no longer want to receive these emails',
              too_frequent: 'The emails are too frequent',
              never_signed: 'I never signed up for the newsletter',
              inappropriate: 'The emails are inappropriate',
              not_interested: 'I am not interested anymore' }.freeze

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :reasons,
            presence: true,
            array_inclusion: { in: REASONS.keys.map(&:to_s) << 'admin' }

  scope :graph, -> { select(:reasons, :created_at) }

  after_commit :change_subscribed_to_false

  def self.count_reason(feedbacks)
    feedbacks
      .reduce([]) { |arr, fb| arr.concat(fb.reasons) }
      .group_by(&:itself)
      .transform_values(&:count)
      .transform_keys do |key|
      REASONS.key?(key.to_sym) ? REASONS[key.to_sym] : key
    end
  end

  private

  def change_subscribed_to_false
    subscriber = NewsletterSubscription.find_by_email(email)
    subscriber&.update(subscribed: false)
  end
end
