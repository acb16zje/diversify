# frozen_string_literal: true

require 'rails_helper'

describe 'Metrics > Dashboard', :js, type: :system do
  let(:admin) { create(:admin) }

  describe 'without Data' do
    before do
      sign_in admin
      visit metrics_path
    end

    context 'when views Landing Page Feedback' do
      it 'shows no Data' do
        find(:xpath, "//*[@id='graph-select']/option[3]").select_option
        expect(page).to have_content('No data')
      end
    end
  end

  describe 'with Data' do
    before do
      create(:landing_feedback)
      sign_in admin
      visit metrics_path
    end

    context 'when views Subscription Ratio' do
      it 'shows Data' do
        find(:xpath, "//*[@id='graph-select']/option[1]").select_option
        expect(page).to have_no_content('No data')
      end
    end

    context 'when views Subscription by Date' do
      it 'shows Data' do
        find(:xpath, "//*[@id='graph-select']/option[2]").select_option
        expect(page).to have_no_content('No data')
      end
    end

    context 'with Landing Page Feedback' do
      it 'shows Data' do
        find(:xpath, "//*[@id='graph-select']/option[3]").select_option
        expect(page).to have_no_content('No data')
      end
    end
  end
end
