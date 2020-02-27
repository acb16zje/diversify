require 'rails_helper'

describe 'Navigations > Feedback', :js, type: :system do
  before do
    visit Feedback_pages_path
  end

  it do
    expect(page).to have_content('Help us improve')
  end

  describe 'submit the feedback form' do

    it 'choose all the options' do

    end

    it 'not choose emojis' do

    end

    it 'not choose drop down' do

    end

  end

end
