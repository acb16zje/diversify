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
  include DateScope
end
