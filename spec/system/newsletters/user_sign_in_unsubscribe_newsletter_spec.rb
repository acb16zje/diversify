# frozen_string_literal: true

require 'rails_helper'

describe 'Logged in page Newsletter > Subscribe', :js, type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it 'can unsubscribes' do
    visit settings_profile_path
    click_link 'Emails'
    if find_button('Subscribe Newsletter').visible?
      click_button 'Subscribe Newsletter'
      click_button 'Unsubscribe Newsletter'
    else
      click_button 'Unsubscribe Newsletter'
    end
    expect(page).to have_content('Newsletter Unsubscribed')
  end
end
