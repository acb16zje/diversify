# frozen_string_literal: true

require 'rails_helper'

describe NewslettersController, '#show', :js do

  context 'with newsletter' do
    let(:newsletter) { FactoryBot.create(:newsletter) }

    before do
      newsletter # let is lazy load, call this to ensure it is created
    end

    it 'can show newsletter modal' do
      visit newsletters_path
      find('tr', text: newsletter.title).click
      expect(page).to have_content(newsletter.content)
    end

    it 'can view newsletter directly' do
      visit newsletter_path(newsletter)
      expect(page).to have_content(newsletter.content)
    end
  end

  context 'without newsletter' do
    it 'shows no data' do
      visit newsletters_path
      expect(page).to have_content('No data available in table')
    end
  end

end
