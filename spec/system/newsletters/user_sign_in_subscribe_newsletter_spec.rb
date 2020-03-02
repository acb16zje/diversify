# frozen_string_literal: true

require 'rails_helper'
require_relative 'user_helper'

describe 'Logged in page Newsletter > Subscribe', :js, type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
  end
  
  describe 'subscribe newsletter' do
    it 'from settings page' do
      visit settings_profile_path
      click_link_or_button 'Emails'
      click_link_or_button 'Subscribe Newsletter'
      expect(page).to have_content('Newsletter Subscribed')
    end
  end
end
