# frozen_string_literal: true

require 'rails_helper'

describe 'Show User > Profile', :js, type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
    visit user_path(user)
  end

  describe 'show user profile' do
    it 'shows user profile' do
      expect(page).to have_content(user.email)
    end
  end

  describe 'can redirect to edit user profile' do
    it 'redirects to user profile' do
      click_link 'Edit'
      expect(page).to have_content('Public Avatar')
    end
  end
end
