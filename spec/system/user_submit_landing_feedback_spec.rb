# frozen_string_literal: true

require 'rails_helper'

describe 'Landing page > Feedback', :js, type: :feature do
  before { visit feedback_pages_path }

  it 'can submit feedback' do
    choose option: 'neutral'
    select('Newspaper', from: 'landing_feedback_channel').select_option
    click_button 'Submit'
    expect(page).to have_content('Thank you for your feedback')
  end

  describe 'cannot submit feedback' do

    it 'not choose emojis' do
      select('Social Media', from: 'landing_feedback_channel').select_option
      click_button 'Submit'
      expect(page).not_to have_content('Thank you for your feedback')
    end

    it 'not choose drop down' do
      choose option: 'sad'
      click_button 'Submit'
      expect(page).not_to have_content('Thank you for your feedback')
    end
  end
end
