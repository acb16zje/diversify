# frozen_string_literal: true

require 'rails_helper'
require_relative 'user_helper'

describe 'Logged in page Newsletter > Subscribe', :js, type: :system do
  let(:user) { create(:user) }

  describe 'never subscribed before' do
    it 'from landing page' do
      visit new_user_session_path
      fill_form(user.email, user.password)
      click_button 'Sign in'
      click_link_or_button 'Get Started for Free'
      click_link_or_button 'Get started for free'
      expect(page).to have_content('Subscribe in Settings Page')
      click_link_or_button 'Subscribe in Settings Page'
    end

    it 'from settings page' do
      visit settings_profile_path
      fill_form(user.email, user.password)
      click_button 'Sign in'
      click_link_or_button 'Emails'
      click_link_or_button 'Subscribe Newsletter'
      expect(page).to have_content('Newsletter Subscribed')
    end
  end
end
