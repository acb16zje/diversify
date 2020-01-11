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

# LandingFeedback model
class LandingFeedback < ApplicationRecord
  include DateScope

  CHANNEL = [
    'Social Media',
    'Search Engine',
    'Newspaper',
    'Recommended by others'
  ].freeze

  validates :smiley, presence: true
  validates :channel, presence: true, inclusion: { in: CHANNEL }
end
