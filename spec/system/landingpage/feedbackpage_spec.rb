require 'rails_helper'

describe 'Navigations > Feedback', :js, type: :system do
  before do
    visit feedback_pages_path
  end

  it do
    expect(page).to have_content('Help us improve')
  end

  describe 'submit the feedback form' do

    it 'choose all the options' do
      choose(option: 'neutral')
      select('Newspaper', :from => 'landing_feedback_channel').select_option
      click_button 'Submit'
      expect(page).to have_content('Thank you for your feedback')
    end

    it 'not choose emojis' do
      select('Social Media', :from => 'landing_feedback_channel').select_option
      click_button 'Submit'
      expect(page).not_to have_content('Thank you for your feedback')
    end

    it 'not choose drop down' do
      choose(option: 'sad')
      click_button 'Submit'
      expect(page).not_to have_content('Thank you for your feedback')
    end

  end

end
