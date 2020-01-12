# frozen_string_literal: true

# == Schema Information
#
# Table name: newsletters
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Newsletter model
class Newsletter < ApplicationRecord

  has_rich_text :content

  validates :title, :content, presence: true
  validates :content, presence: true

  scope :graph, lambda {
    select(:title, :created_at, 'COUNT(newsletter_feedbacks) as feedback_count')
      .joins(
        "INNER JOIN newsletter_feedbacks ON newsletter_feedbacks.created_at
         BETWEEN newsletters.created_at
         AND newsletters.created_at + interval '7 days'"
      ).group(:id)
  }

  after_commit :send_newsletter, on: :create

  private

  def send_newsletter
    NewsletterSubscription.all_subscribed_emails.each_slice(50) do |emails|
      NewsletterMailer.send_newsletter(emails, self).deliver_later
    end
  end
end
