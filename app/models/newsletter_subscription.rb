# frozen_string_literal: true

# == Schema Information
#
# Table name: newsletter_subscriptions
#
#  id              :bigint           not null, primary key
#  date_subscribed :date             not null
#  email           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_newsletter_subscriptions_on_email  (email) UNIQUE
#

# NewsletterSubscription Model
class NewsletterSubscription < ApplicationRecord
  validates :email,
            uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }

  scope :onDate, lambda { |time|
    where('created_at BETWEEN ? AND ?',
          DateTime.parse(time),
          DateTime.parse(time) + 1.days)
  }

  scope :betweenDate, lambda { |time1, time2|
    where('created_at BETWEEN ? AND ?',
          DateTime.parse(time1),
          DateTime.parse(time2) + 1.days)
  }

  def self.all_emails
    pluck(:email)
  end

  def self.send_newsletter(newsletter)
    all_emails.each_slice(50) do |emails|
      NewsletterMailer.send_newsletter(emails, newsletter).deliver_later
    end
  end
end
