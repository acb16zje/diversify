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
  include DateScope

  has_rich_text :content
  validates_presence_of :title, :content

  scope :graph, lambda {
    find_by_sql(
      "SELECT newsletters.title,
         newsletters.created_at, COUNT(newsletter_feedbacks)
         as feedback_count FROM newsletters JOIN newsletter_feedbacks
         ON newsletter_feedbacks.created_at BETWEEN newsletters.created_at
         AND newsletters.created_at+interval\'7 days\' GROUP BY newsletters.id"
    )
  }

  after_commit :send_newsletter, on: :create

  private

  def send_newsletter
    NewsletterSubscription.delay.send_newsletter(self)
  end
end
