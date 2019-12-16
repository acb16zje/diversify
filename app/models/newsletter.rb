# frozen_string_literal: true

# == Schema Information
#
# Table name: newsletters
#
#  id         :bigint           not null, primary key
#  content    :text             not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Newsletter model
class Newsletter < ApplicationRecord
  include DateScope

  scope :graph, -> { find_by_sql(
                    "SELECT newsletters.title,
           newsletters.created_at, COUNT(newsletter_feedbacks)
           as feedback_count FROM newsletters JOIN newsletter_feedbacks
           ON newsletter_feedbacks.created_at BETWEEN newsletters.created_at
           AND newsletters.created_at+interval\'7 days\' GROUP BY newsletters.id"
                  )
                }

  validates_presence_of :title, :content
end
