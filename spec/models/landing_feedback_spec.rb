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


require 'rails_helper'

describe LandingFeedback, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:smiley) }
    it { is_expected.to validate_presence_of(:channel) }

    it {
      is_expected.to validate_inclusion_of(:channel)
        .in_array(described_class::CHANNEL)
    }
  end
end
