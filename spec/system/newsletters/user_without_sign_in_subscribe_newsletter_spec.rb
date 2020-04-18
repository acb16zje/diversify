# frozen_string_literal: true

require 'rails_helper'

describe 'Landing page Newsletter > Subscribe', :js, type: :system do
  before { visit newsletter_pages_path }

  def subscribe(email_presence = false, unsubscribed = false)
    subscriber = create(:newsletter_subscription, subscribed: !unsubscribed)
    fill_in 'email', with: email_presence ? subscriber.email : 'null@null.com'
    click_button 'Subscribe'
  end

  def empty_email_subscribe
    page.evaluate_script("document.getElementById('email').name = 'null'")
    page.evaluate_script("document.getElementById('email').type = 'null'")
    page.evaluate_script("document.getElementById('email').required = 'false'")
    fill_in 'null', with: 'qwerty'
    click_button 'Subscribe'
  end

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
