# frozen_string_literal: true

require 'rails_helper'

describe 'Metrics > Dashboard', :js, type: :system do
  let(:admin) { create(:admin) }

  describe 'with Data' do
    before do
      create(:ahoy_event, :free)
      create(:ahoy_event, :pro)
      create(:ahoy_event, :ultimate)
      create(:landing_feedback)
      sign_in admin
      visit metrics_path
    end
    context 'in Subscription Ratio' do
      it 'shows Data' do
        find(:xpath, "//*[@id='graph-select']/option[1]").select_option
        expect(page).to have_no_content('No data')
      end
    end

    context 'in Subscription by Date' do
      it 'shows Data' do
        find(:xpath, "//*[@id='graph-select']/option[2]").select_option
        expect(page).to have_no_content('No data')
      end
    end

    context 'in Landing Page Feedback' do
      it 'shows Data' do
        find(:xpath, "//*[@id='graph-select']/option[3]").select_option
        expect(page).to have_no_content('No data')
      end
    end
  end

  describe 'without Data' do
    before do
      sign_in admin
      visit metrics_path
    end
    context 'in Subscription Ratio' do
      it 'shows no Data' do
        find(:xpath, "//*[@id='graph-select']/option[1]").select_option
        expect(page).to have_content('No data')
      end
    end

    context 'in Subscription by Date' do
      it 'shows bo Data' do
        find(:xpath, "//*[@id='graph-select']/option[2]").select_option
        expect(page).to have_content('No data')
      end
    end

    context 'in Landing Page Feedback' do
      it 'shows bo Data' do
        find(:xpath, "//*[@id='graph-select']/option[3]").select_option
        expect(page).to have_content('No data')
      end
    end
  end
end
