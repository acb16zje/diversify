# frozen_string_literal: true

# == Schema Information
#
# Table name: landing_feedbacks
#
#  id         :bigint           not null, primary key
#  channel    :string           default(""), not null
#  interest   :boolean          default(TRUE)
#  smiley     :string           default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class LandingFeedback < ApplicationRecord
  scope :onDate, lambda { |time|
                   where('created_at BETWEEN ? AND ?',
                         DateTime.parse(time), DateTime.parse(time) + 1.days)
                 }
  scope :betweenDate, lambda { |time1, time2|
                        where('created_at BETWEEN ? AND ?',
                              DateTime.parse(time1),
                              DateTime.parse(time2) + 1.days)
                      }
end
