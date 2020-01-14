# frozen_string_literal: true

require 'rails_helper'

describe 'Metrics > Traffic : Overview', :js, type: :feature do
  before { visit traffic_metrics_path }

  it { expect(page).to have_content('Demographics') }
end
