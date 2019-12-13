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
end
