# frozen_string_literal: true

require 'rails_helper'

describe 'ErrorPages', type: :feature do
  shared_examples 'shows landing page nav links' do
    it { expect(page).to have_link('Newsletter', href: newsletter_pages_path) }
  end

  describe '403' do
    before { visit '/403' }

    it { expect(page).to have_content('403') }

    it_behaves_like 'shows landing page nav links'
  end

  describe '404' do
    before { visit '/404' }

    it { expect(page).to have_content('404') }

    it_behaves_like 'shows landing page nav links'
  end

  describe '422' do
    before { visit '/422' }

    it { expect(page).to have_content('422') }

    it_behaves_like 'shows landing page nav links'
  end

  describe '500' do
    before { visit '/500' }

    it { expect(page).to have_content('500') }

    it_behaves_like 'shows landing page nav links'
  end
end
