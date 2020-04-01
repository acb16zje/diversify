# frozen_string_literal: true

require 'rails_helper'

describe 'Metrics > Subscriber Management', :js, type: :system do
  let(:admin) { create(:admin) }

  context 'without subscriber' do
    it 'shows no data' do
      sign_in admin
      visit subscribers_newsletters_path
      expect(page).to have_content('No data')
    end
  end

  context 'with subscribers' do
    let!(:subscribed_1) { create(:newsletter_subscription) }
    let!(:subscribed_2) { create(:newsletter_subscription, created_at: 1.day.ago) }
    let!(:subscribed_3) { create(:newsletter_subscription) }
    let!(:subscribers) { create_list(:newsletter_subscription, 15) }

    before do
      sign_in admin
      visit subscribers_newsletters_path
    end

    it 'can see subscribers' do
      expect(page).to have_content(subscribed_1.email)
    end

    it 'can unsubscribe user' do
      accept_confirm { find('tr', text: subscribed_1.email).find('td.has-text-centered').click }
      expect(page).to have_no_content(subscribed_1.email)
    end

    it 'can search user by date subscribed' do
      all('input[class="input"]')[1].set(Time.zone.yesterday)
      expect(page).to have_content(subscribed_2.email)
    end

    it 'can search user by email' do
      all('input[class="input"]')[0].set(subscribed_3.email)
      expect(page).to have_content(subscribed_3.email)
    end

    it 'can sort list by Email' do
      find('th', text: 'Email').click
      within(:xpath, '//tr[1]/td') do
        expect(page).to have_content(subscribed_1.email)
      end
    end

    it 'can sort list by Date Subscribed' do
      find('th', text: 'Date Subscribed').click
      within(:xpath, '//tr[1]/td') do
        expect(page).to have_content(subscribed_2.email)
      end
    end

    it 'can view next page' do
      find('a', text: '2').click
      expect(page).to have_no_content(subscribed_1.email)
    end
  end
end
