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

class NewsletterSubscription < ApplicationRecord
    validates :email, presence: true

    scope :onDate, ->(time) { where("created_at BETWEEN ? AND ?", DateTime.parse(time),DateTime.parse(time)+1.days)}
    scope :betweenDate, ->(time1,time2) { where("created_at BETWEEN ? AND ?", DateTime.parse(time1),DateTime.parse(time2)+1.days)}
end
