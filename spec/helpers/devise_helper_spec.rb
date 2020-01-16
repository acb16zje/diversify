# frozen_string_literal: true

require 'rails_helper'

describe DeviseHelper, type: :helper do
  describe '#provider_label' do
    it { expect(provider_label(:google_oauth2)).to eq 'Google' }
    it { expect(provider_label(:facebook)).to eq 'Facebook' }
    it { expect(provider_label(:twitter)).to eq 'Twitter' }
  end

  describe '#provider_icon' do
    it { expect(provider_icon(:google_oauth2)).to eq 'flat-color-icons:google' }
    it { expect(provider_icon(:facebook)).to eq 'fe:facebook' }
    it { expect(provider_icon(:twitter)).to eq 'fe:twitter' }
  end
end
