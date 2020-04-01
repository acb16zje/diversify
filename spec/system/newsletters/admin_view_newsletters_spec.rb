# frozen_string_literal: true

require 'rails_helper'

describe 'Metrics > Newsletter Archive', :js, type: :system do
  let(:admin) { create(:admin) }

  before { sign_in admin }

  context 'with newsletter' do
    let(:newsletter) { create(:newsletter) }

    before do
      newsletter # let is lazy load, call this to ensure it is created
    end

    it 'can show newsletter modal' do
      visit newsletters_path
      find('tr', text: newsletter.title).click
      within '.modal-card' do
        expect(page).to have_content('some content of the email')
      end
    end

    it 'can view newsletter directly' do
      visit newsletter_path(newsletter)
      expect(page).to have_content('some content of the email')
    end
  end

  context 'without newsletter' do
    it 'shows no data' do
      visit newsletters_path
      expect(page).to have_content('No data')
    end

    it 'return 404 page' do
      visit newsletter_path(404)
      expect(page).to have_content('404')
    end
  end
end
