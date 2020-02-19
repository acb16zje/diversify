# frozen_string_literal: true

require 'rails_helper'

describe 'Metrics > Dashboard', :js, type: :feature do
  describe 'Subscriptions by Date' do
    context 'with data' do
      before do
        create(:ahoy_event, :free)
        create(:ahoy_event, :pro)
        create(:ahoy_event, :ultimate)

        visit metrics_path
      end

      it { expect(page).to have_no_content('No Data') }
    end

    context 'without data' do
      it 'shows No Data' do
        visit metrics_path
        select 'Subscriptions by Date', from: 'graph-select'
        wait_for_ajax
        expect(page).to have_content('No Data')
      end
    end
  end
end
