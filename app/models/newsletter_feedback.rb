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

class NewsletterFeedback < ApplicationRecord
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}

  scope :onDate, ->(time) { where("created_at BETWEEN ? AND ?", DateTime.parse(time), DateTime.parse(time) + 1.days) }
  scope :betweenDate, ->(time1, time2) { where("created_at BETWEEN ? AND ?", DateTime.parse(time1), DateTime.parse(time2) + 1.days) }
end
