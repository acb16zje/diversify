# frozen_string_literal: true

require 'rails_helper'

describe ApplicationController do
  describe '#flash_class' do
    it { expect(controller.send(:flash_class, 'null')).to eq('is-primary') }
  end

end
