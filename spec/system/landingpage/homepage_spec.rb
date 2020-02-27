require 'rails_helper'

describe 'Navigations > Root', :js, type: :system do

  before do
    visit root_path
  end

  describe 'access homepage' do
    it 'from navigation bar' do
      find("img[src*='logo_horizontal']").click
      expect(page).to have_content('Introduction')
    end

    it 'from footbar' do
      find("img[src*='logo_vertical']").click
      expect(page).to have_content('Introduction')
    end
  end

  describe 'access to other pages' do
    it 'to pricing page' do
      click_link_or_button 'Pricing'
      expect(page).to have_content('Pricing plans')
    end

    it 'to about page' do
      click_link_or_button 'About'
      expect(page).to have_content('Our Team')
    end

    it 'to love page`' do
      click_link_or_button 'Customers'
      expect(page).to have_content('Hear more from')
    end

    it 'to features page' do
      click_link_or_button 'Features'
      expect(page).to have_content('Join teams and create')
    end

    it 'to newsletter page' do
      click_link_or_button 'Newsletter'
      expect(page).to have_content('Subscribe to our')
    end

    it 'to contact page' do
      click_link_or_button 'Contact Us'
      expect(page).to have_content('Contact Us')
    end

    it 'to feedback page' do
      click_link_or_button 'Feedback'
      expect(page).to have_content('Help us improve')
    end
  end
end
