# frozen_string_literal: true

require 'rails_helper'

describe 'Show Dashboard > Admin', :js, type: :system do
  let(:admin) { create(:admin) }

  before do
    sign_in admin
    visit admin_dashboard_index_path
  end

  describe 'show dashboard index page' do
    it 'shows dashboard content' do
      expect(page).to have_content('Total users')
        .and have_content('Total projects')
        .and have_content('Total categories')
        .and have_content('Total skills')
    end
  end
end
