# frozen_string_literal: true

require 'rails_helper'

describe 'Metrics > Send newsletter', :js, type: :feature do
  before do
    visit new_newsletter_path
    instance_double(NewsletterSubscription.name, email: 'test@test.com')
  end

  describe 'sending a newsletter' do
    before { send_newsletter }

    it { expect(page).to have_current_path(newsletters_path) }
    it { expect(page).to have_content('random title') }
  end

  describe 'sending an incomplete newsletter' do
    before { send_newsletter(false) }

    it { expect(page).to have_content('Send Failed') }
  end
end
