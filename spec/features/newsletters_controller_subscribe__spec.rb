# frozen_string_literal: true

require 'rails_helper'

describe NewslettersController, '#subscribe', :js do

  before { visit newsletter_pages_path }

  context 'with t.subscribed = false' do
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

  context 'with t.subscribed = true' do
    it 'can subscribe again if unsubscribed before' do
      subscribe(true, true)
      expect(page).to have_content('Newsletter Subscribed')
    end
  end
end
