# frozen_string_literal: true

require 'rails_helper'

describe 'Metrics > Subscriber Management', :js, type: :system do
  let(:admin) { create(:admin) }
  let(:subscriber) { create(:newsletter_subscription, subscribed: true) }

  before do
    sign_in admin
    visit subscribers_newsletters_path
  end

  context 'without subscriber' do
    it 'shows no data' do
      expect(page).to have_content('No data')
    end
  end

  context 'with subscribers' do
    it 'can see subscribers' do
      expect(page).to have_content(subscriber.email)
    end

    it 'can unsubscribe user' do
      accept_confirm { find("tr#subscriber#{subscriber.id} td a").click }
      expect(page).to have_no_content(subscriber.email)
    end
  end
end
