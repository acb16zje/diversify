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

# NewsletterFeedback model
class NewsletterFeedback < ApplicationRecord
  include DateScope

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  @graph_dict = { no_longer: 'I no longer want to receive these emails',
                  too_frequent: 'The emails are too frequent',
                  never_signed: 'I never signed up for the newsletter',
                  inappropriate: 'The emails are inappropriate',
                  not_interested: 'I am not interested anymore' }

  scope :graph, -> { select(:reason, :created_at) }

  def self.count_reason(feedbacks)
    array = feedbacks
            .reduce([]) { |arr, fb| arr.concat(fb.reason.split(' ')) }
            .group_by { |e| e }
            .map { |k, v| [k, v.length] }.to_h

    @graph_dict.map { |k, v| array[v] = array.delete(k.to_s) }

    array
  end
end
