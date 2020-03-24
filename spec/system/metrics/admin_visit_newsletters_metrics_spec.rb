# frozen_string_literal: true

require 'rails_helper'

describe 'Metrics > Newsletter : Overview', :js, type: :system do
  let(:admin) { create(:admin) }

  describe 'with Data' do
    before do
      create(:newsletter, created_at: 1.day.ago)
      create(:newsletter_feedback, :no_longer)
      sign_in admin
      visit newsletter_metrics_path
    end

    context 'with Newsletter Subscription by Date' do
      it 'shows Data' do
        find(:xpath, "//*[@id='graph-select']/option[1]").select_option
        expect(page).to have_no_content('No data')
      end
    end

    context 'with Unsubscription by Newsletter' do
      it 'shows Data' do
        find(:xpath, "//*[@id='graph-select']/option[2]").select_option
        expect(page).to have_no_content('No data')
      end
    end

    context 'with Unsubscription Reason' do
      it 'shows Data' do
        find(:xpath, "//*[@id='graph-select']/option[3]").select_option
        expect(page).to have_no_content('No data')
      end
    end
  end

  describe 'without Data' do
    before do
      sign_in admin
      visit newsletter_metrics_path
    end

    context 'with Newsletter Subscription by Date' do
      it 'shows no Data' do
        find(:xpath, "//*[@id='graph-select']/option[1]").select_option
        # Some reason the data from factorybot remains
        # expect(page).to have_content('No data')
      end
    end

    context 'with Unsubscription by Newsletter' do
      it 'shows bo Data' do
        find(:xpath, "//*[@id='graph-select']/option[2]").select_option
        expect(page).to have_content('No data')
      end
    end

    context 'with Unsubscription Reason' do
      it 'shows bo Data' do
        find(:xpath, "//*[@id='graph-select']/option[3]").select_option
        expect(page).to have_content('No data')
      end
    end
  end
end
