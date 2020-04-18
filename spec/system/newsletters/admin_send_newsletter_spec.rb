# frozen_string_literal: true

require 'rails_helper'

describe 'Metrics > Send newsletter', :js, type: :system do
  let(:admin) { create(:admin) }

  def send_newsletter(has_content = true)
    fill_in 'newsletter_title', with: 'random title'
    find('trix-editor').click.set('random text') if has_content
    click_button 'Send newsletter'
  end

  before do
    sign_in admin
    visit new_newsletter_path
    instance_double(NewsletterSubscription.name, email: 'test@test.com')
  end

  describe 'sending a newsletter' do
    before { send_newsletter }

    it { expect(page).to have_content('random title') }
  end

  describe 'sending an incomplete newsletter' do
    before { send_newsletter(false) }

    it { expect(page).to have_content('Send Failed') }
  end
end
