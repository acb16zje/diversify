# frozen_string_literal: true

require 'rails_helper'

describe 'Metrics > Newsletter : Overview', :js, type: :feature do
  before { visit newsletter_metrics_path }

  describe 'Newsletter Unsubscriptions by Newsletter' do
    context 'with data' do
      before do
        create(:newsletter, created_at: 1.day.ago)
        create(:newsletter_feedback, no_longer: true)
        select 'Unsubscriptions by Newsletter', from: 'graph-select'
      end

      it { expect(page).to have_no_content('No Data') }
    end
  end

  describe 'Newsletter Unsubscription Reason' do
    context 'with data' do
      let(:feedback) { create(:newsletter_feedback, no_longer: true) }

      before do
        feedback
        select 'Unsubscription Reason', from: 'graph-select'
      end

      it { expect(page).to have_no_content('No Data') }
    end
  end
end
