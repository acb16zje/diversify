# frozen_string_literal: true

# == Schema Information
#
# Table name: newsletter_feedbacks
#
#  id                         :bigint           not null, primary key
#  email                      :string           default(""), not null
#  reasons                    :string           default([]), not null, is an Array
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  newsletter_subscription_id :bigint           not null
#
# Indexes
#
#  index_newsletter_feedbacks_on_newsletter_subscription_id  (newsletter_subscription_id)
#
# Foreign Keys
#
#  fk_rails_...  (newsletter_subscription_id => newsletter_subscriptions.id)
#

class NewsletterFeedback < ApplicationRecord
  REASONS = { no_longer: 'I no longer want to receive these emails',
              too_frequent: 'The emails are too frequent',
              never_signed: 'I never signed up for the newsletter',
              inappropriate: 'The emails are inappropriate',
              not_interested: 'I am not interested anymore' }.freeze

  belongs_to :newsletter_subscription, optional: true

  validates :reasons,
            presence: true,
            array_inclusion: { in: REASONS.keys.map(&:to_s) << 'admin' }

  before_save :validate_subscription_status

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

  # Disallow submitting multiple feedback after unsubscription
  def validate_subscription_status
    throw :abort unless newsletter_subscription&.subscribed?
  end

  def change_subscribed_to_false
    newsletter_subscription&.unsubscribe
  end
end
