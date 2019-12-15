# frozen_string_literal: true

require 'rails_helper'

describe NewslettersController, '#subscribers', :js do

  context 'with subscribers' do
    let(:subscriber) { FactoryBot.create(:subscriber) }

    before do
      subscriber
      visit subscribers_newsletters_path
    end

    specify 'can see subscribers' do
      expect(page).to have_content(subscriber.email)
    end
  end

  context 'without subscriber' do
    it 'shows no data' do
      visit subscribers_newsletters_path
      expect(page).to have_content('No data available in table')
    end
  end
end
