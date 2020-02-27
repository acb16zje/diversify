require 'rails_helper'

describe 'Navigations > Love', :js, type: :system do
  before do
    visit love_pages_path
  end

  it do
    expect(page).to have_content('Hear more from people like you')
  end

  it 'find out more' do
    click_link_or_button 'Get Started for Free'
    expect(page).to have_content('Pricing plans')
  end
end
