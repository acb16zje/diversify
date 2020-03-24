# frozen_string_literal: true

require 'rails_helper'

describe 'Metrics > Traffic : Overview', :js, type: :system do
  let(:admin) { create(:admin) }

  describe 'with Data' do
    before do
      create(:ahoy_event, :pricing_link)
      sign_in admin
      visit traffic_metrics_path
    end

    it { expect(page).to have_no_content('No data') }

    context 'with Referrers Ratio' do
      it 'shows Data' do
        find(:xpath, "//*[@id='graph-select']/option[1]").select_option
        expect(page).to have_no_content('No data')
      end
    end

    context 'with Referrers by Date' do
      it 'shows Data' do
        find(:xpath, "//*[@id='graph-select']/option[2]").select_option
        expect(page).to have_no_content('No data')
      end
    end

    context 'with Average Time Spent per Page' do
      it 'shows Data' do
        find(:xpath, "//*[@id='graph-select']/option[3]").select_option
        expect(page).to have_no_content('No data')
      end
    end

    context 'with Number of Visits per Page' do
      it 'shows Data' do
        find(:xpath, "//*[@id='graph-select']/option[4]").select_option
        expect(page).to have_no_content('No data')
      end
    end
  end

  describe 'without Data' do
    before do
      sign_in admin
      visit traffic_metrics_path
    end

    it { expect(page).to have_content('No data') }

    context 'with Referrers Ratio' do
      it 'shows Data' do
        find(:xpath, "//*[@id='graph-select']/option[1]").select_option
        expect(page).to have_content('No data')
      end
    end

    context 'with Referrers by Date' do
      it 'shows Data' do
        find(:xpath, "//*[@id='graph-select']/option[2]").select_option
        expect(page).to have_content('No data')
      end
    end

    context 'with Average Time Spent per Page' do
      it 'shows Data' do
        find(:xpath, "//*[@id='graph-select']/option[3]").select_option
        expect(page).to have_content('No data')
      end
    end

    context 'with Number of Visits per Page' do
      it 'shows Data' do
        find(:xpath, "//*[@id='graph-select']/option[4]").select_option
        expect(page).to have_content('No data')
      end
    end
  end
end
