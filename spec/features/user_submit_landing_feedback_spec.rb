# frozen_string_literal: true

require 'rails_helper'

describe 'Landing page > Feedback', :js, type: :feature do
  before { visit feedback_pages_path }

  it 'can submit feedback' do
    choose 'smiley_neutral'
    select 'Newspaper', from: 'channel'
    click_button 'Submit'
  end
end
