require 'rails_helper'

describe PagesController do

  describe 'Visiting /, the home page' do
    context 'As a user' do

      specify 'I can visit the home page' do
        visit root_path
        expect(page).to have_content 'Introduction'
      end

    end
  end

  describe 'Visiting /pricing, the pricing page' do
    context 'As a user' do

      specify 'I can visit the pricing page' do
        visit pricing_pages_path
        expect(page).to have_content 'Pricing plans'
      end

    end
  end

  describe 'Visiting /about, the about page' do
    context 'As a user' do

      specify 'I can visit the about page' do
        visit about_pages_path
        expect(page).to have_content 'Our Team'
      end

      specify 'I can see the Contact Us section under about page' do
        visit about_pages_path
        expect(page).to have_content 'Contact Us'
      end

    end
  end

  describe 'Visiting /love, the customers page' do
    context 'As a user' do

      specify 'I can visit the customers page' do
        visit love_pages_path
        expect(page).to have_content '#diversifylove'
      end

    end
  end

  describe 'Visiting /features, the features page' do
    context 'As a user' do

      specify 'I can visit the features page' do
        visit features_pages_path
        expect(page).to have_content 'Join and Collaborate'
        expect(page).to have_content 'Analyse and Maintain'
        expect(page).to have_content 'Rate and Review'
      end

    end
  end

  describe 'Visiting /newsletter, the newsletter page' do
    context 'As a user' do

      specify 'I can visit the newsletter page' do
        visit newsletter_pages_path
        expect(page).to have_content 'Subscribe to our newsletter'
      end

    end
  end

  describe 'Visiting /feedback, the feedback page' do
    context 'As a user' do

      specify 'I can visit the feedback page' do
        visit feedback_pages_path
        expect(page).to have_content 'Help us improve'
      end

    end
  end

end
