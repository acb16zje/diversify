require 'rails_helper'

describe 'Navigations > About', :js, type: :system do
  before do
    visit about_pages_path
  end

  it 'give feedback' do
    click_link_or_button 'Give us feedback'
    expect(page).to have_content('Help us improve')
  end

  it 'want to sign up newsletter' do
    click_link_or_button 'Sign up'
    expect(page).to have_content('Subscribe to our newsletter')
  end

  it 'want to join mailing list' do
    click_link_or_button 'Join our mailing list'
    expect(page).to have_content('Subscribe to our newsletter')
  end

  it 'want to know about team' do
    click_link_or_button 'Get to know the wonderful team'
    expect(page).to have_content('Get to know the wonderful team')
  end

end
