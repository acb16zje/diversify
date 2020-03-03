# frozen_string_literal: true

require 'rails_helper'

describe 'edit Profile > User', :js, type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
    visit settings_profile_path
  end

  describe 'show edit profile page page' do
    it 'shows the profile page' do
      expect(page).to have_content('Public Avatar')
    end
  end

  describe 'show correct information' do
    context 'when showing correct user name' do
      it 'displays correct username' do
        expect(page).to have_selector("input[value='#{user.name}']")
      end
    end

    context 'when displaying birthday' do
      it 'displays correct birthdate' do
        # expect(page).to have_selector("input[value='#{user.birthdate}']")
      end
    end
  end
end
