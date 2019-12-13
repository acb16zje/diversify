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

require 'rails_helper'

RSpec.describe LandingFeedback, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
