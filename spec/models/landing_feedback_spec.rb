# frozen_string_literal: true

require 'rails_helper'

describe LandingFeedback, type: :model do
  describe 'modules' do
    it { is_expected.to include_module(DateScope) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:smiley) }
    it { is_expected.to validate_presence_of(:channel) }

    it {
      is_expected.to validate_inclusion_of(:channel)
        .in_array(described_class::CHANNEL)
    }
  end
end
