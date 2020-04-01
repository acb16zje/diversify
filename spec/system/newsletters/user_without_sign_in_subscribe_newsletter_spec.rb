# frozen_string_literal: true

require 'rails_helper'

describe 'Landing page Newsletter > Subscribe', :js, type: :system do
  before { visit newsletter_pages_path }

  describe 'never subscribed before' do
    it 'can subscribe newsletter' do
      subscribe
      expect(page).to have_content('Thanks for subscribing')
    end

    it 'checks email unique constraint' do
      subscribe(true)
      expect(page).to have_content('')
    end

    specify 'type="email" has been changed' do
      empty_email_subscribe
      expect(page).to have_content('Subscription Failed')
    end
  end

  describe 'subscribed before, but unsubscribed' do
    it 'can subscribe again if unsubscribed before' do
      subscribe(true, true)
      expect(page).to have_content('Thanks for subscribing')
    end
  end
end
