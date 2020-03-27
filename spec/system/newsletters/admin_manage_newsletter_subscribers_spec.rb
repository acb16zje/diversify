# frozen_string_literal: true

require 'rails_helper'

describe 'Metrics > Subscriber Management', :js, type: :system do
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }

  # There should have way to create subscribers by factory bot
  before do
    sign_in admin
    visit subscribers_newsletters_path
  end

  context 'without subscriber' do
    it 'shows no data' do
      expect(page).to have_content('No data')
    end
  end

  context 'with subscribers' do
    before do
      sign_in user
      visit settings_profile_path
      click_link_or_button 'Emails'
      click_link_or_button 'Subscribe Newsletter'
    end

    it 'can see subscribers' do
      sign_in admin
      visit subscribers_newsletters_path
      expect(page).to have_content(user.email)
    end

    it 'can unsubscribe user' do
      sign_in admin
      visit subscribers_newsletters_path
      accept_confirm { find('tr', text: user.email).find('td.has-text-centered').click }
      expect(page).to have_no_content(user.email)
    end
    # it 'can search user by email' do
    #
    # end
    #
    # it 'can search user by date subscribed' do
    #
    # end
  end
end
