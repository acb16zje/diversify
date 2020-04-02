# frozen_string_literal: true

# == Schema Information
#
# Table name: landing_feedbacks
#
#  id         :bigint           not null, primary key
#  channel    :string           default(""), not null
#  interest   :boolean          default(TRUE), not null
#  smiley     :string           default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class LandingFeedback < ApplicationRecord
  CHANNEL = [
    'Social Media',
    'Search Engine',
    'Newspaper',
    'Recommended by others'
  ].freeze

  validates :channel, presence: true, inclusion: { in: CHANNEL }
  validates :interest, presence: true
  validates :smiley, presence: true
end
