require 'rails_helper'

describe 'Navigations > Pricing', :js, type: :system do
  before do
    visit pricing_pages_path
  end

  it do
    expect(page).to have_content('Pricing plans')
  end

  it 'try free trial' do
    click_link_or_button 'Start 14-day free trial'
    expect(page).to have_content('Subscribe to our')
  end

  it 'find out more about' do
    click_link_or_button 'Learn more'
    expect(page).to have_content('Join teams and create your own')
  end
end
