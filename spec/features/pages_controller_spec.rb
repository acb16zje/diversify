# frozen_string_literal: true

require 'rails_helper'

describe PagesController do

  describe 'visit /, the home page' do
    it 'can see introduction content' do
      visit root_path
      expect(page).to have_content 'Introduction'
    end
  end

  describe 'visit /pricing, the pricing page' do
    it 'can see pricing plans' do
      visit pricing_pages_path
      expect(page).to have_content 'Pricing plans'
    end
  end

  describe 'visit /about, the about page' do
    before do
      visit about_pages_path
    end

    it 'can see team members' do
      expect(page).to have_content 'Our Team'
    end

    it 'can see the Contact Us section at the bottom' do
      expect(page).to have_content 'Contact Us'
    end
  end

  describe 'Visiting /love, the customers page' do
    it 'can see customer reviews' do
      visit love_pages_path
      expect(page).to have_content '#diversifylove'
    end
  end

  describe 'Visiting /features, the features page' do
    it 'can see product features' do
      visit features_pages_path
      expect(page).to have_content 'Join and Collaborate'
    end
  end

  describe 'Visiting /newsletter, the newsletter page' do
    it 'can see an input form' do
      visit newsletter_pages_path
      expect(page).to have_field('email')
    end
  end

  describe 'Visiting /feedback, the feedback page' do

    specify 'I can visit the feedback page' do
      visit feedback_pages_path
      expect(page).to have_content 'Help us improve'
    end
  end

end
