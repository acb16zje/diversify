# frozen_string_literal: true

require 'rails_helper'

describe 'Logged in page Newsletter > Unsubscribe', :js, type: :system do
  let(:user) { create(:user, :newsletter) }

  before do
    sign_in user
  end

  it 'can unsubscribes' do
    visit settings_profile_path
    click_link 'Emails'
    click_button 'Unsubscribe Newsletter'
    expect(page).to have_content('Newsletter Unsubscribed')
  end
end
