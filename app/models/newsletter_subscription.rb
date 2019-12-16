# frozen_string_literal: true

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

# NewsletterSubscription Model
class NewsletterSubscription < ApplicationRecord
  include DateScope

  validates :email,
            uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }

  scope :all_subscribed_emails, -> { where(subscribed: true).pluck(:email) }
  scope :previously_subscribed, -> { where(subscribed: false) }

  def self.send_newsletter(newsletter)
    all_subscribed_emails.each_slice(50) do |emails|
      NewsletterMailer.send_newsletter(emails, newsletter).deliver_later
    end
  end
end
