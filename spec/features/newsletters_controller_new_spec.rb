# frozen_string_literal: true

require 'rails_helper'

describe NewslettersController, '#new', :js do
  before do
    visit new_newsletter_path
    FactoryBot.create(:subscriber)
  end

  describe '#create (send newsletter)' do
    before { send_newsletter }

    it { expect(page).to have_current_path(newsletters_path) }
    it { expect(page).to have_content('random title') }
  end

  specify '#create, Newsletter model validation' do
    send_newsletter(false)
    expect(page).to have_content('Send Failed')
  end
end
