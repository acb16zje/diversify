# frozen_string_literal: true

require 'rails_helper'

describe NewslettersController, '#unsubscribe', :js do
  describe '#unsubscribe', :js do
    before { visit unsubscribe_newsletters_path }

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
