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
    validates :email, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP}
end
