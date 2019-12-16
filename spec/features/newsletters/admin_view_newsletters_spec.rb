# frozen_string_literal: true

require 'rails_helper'

describe 'Metrics > Newsletter Archive', type: :feature do

  context 'with newsletter' do
    let(:newsletter) { create(:newsletter) }

    before do
      newsletter # let is lazy load, call this to ensure it is created
    end

    it 'can show newsletter modal', :js do
      visit newsletters_path
      find('tr', text: newsletter.title).cl2ick
      expect(page).to have_content(newsletter.content)
    end

    it 'can view newsletter directly' do
      visit newsletter_path(newsletter)
      expect(page).to have_content(newsletter.content)
    end
  end

  context 'without newsletter' do
    it 'shows no data', :js do
      visit newsletters_path
      expect(page).to have_content('No data available in table')
    end

    it 'return 404 page' do
      visit newsletter_path(404)
      expect(page).to have_content('404')
    end
  end

end
