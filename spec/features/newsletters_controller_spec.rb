# frozen_string_literal: true

require 'rails_helper'

describe NewslettersController do
  include NewsletterHelper

  describe '#new', :js do
    before do
      visit new_newsletter_path
      FactoryBot.create(:subscriber)
    end

    specify '#create (send newsletter)' do
      send_newsletter
      expect(page).to have_content('rspec title')
    end

    specify '#create, Newsletter model validation' do
      send_newsletter(false)
      expect(page).to have_content('Send Failed')
    end
  end

  describe '#subscribe', :js do
    before do
      visit newsletter_pages_path
    end

    it 'can subscribe newsletter' do
      subscribe
      expect(page).to have_content('Newsletter Subscribed')
    end

    it 'checks email unique constraint' do
      subscribe(true)
      expect(page).to have_content('Subscription Failed')
    end

    specify 'type="email" has been changed' do
      empty_email_subscribe
      expect(page).to have_content('No Email')
    end
  end

  describe '#unsubscribe', :js do
    before do
      visit unsubscribe_newsletters_path
    end

    it 'can unsubscribe from the newsletter' do
      unsubscribe
      expect(page).to have_content('Newsletter Unsubscribed')
    end

    it 'check subscription presence constraint' do
      unsubscribe(false)
      expect(page).to have_content('email is not subscribed')
    end

    it 'check reason presence constraint' do
      unsubscribe(true, false)
      expect(page).to have_content('Please select a reason')
    end
  end

end
