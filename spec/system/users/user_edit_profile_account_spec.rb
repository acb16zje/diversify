# frozen_string_literal: true

require 'rails_helper'

describe 'Edit User Profile > Settings', :js, type: :system do
  let(:omniauth_user) { create(:user, password_automatically_set: true) }

  let(:manual_user) { create(:user) }

  describe 'show account settings' do
    before do
      sign_in manual_user
      visit settings_account_path
    end

    it 'shows user profile' do
      expect(page).to have_content('Social Accounts')
    end
  end

  describe 'present correct form to user' do
    context 'when user has automatic password' do
      before do
        sign_in omniauth_user
        visit settings_account_path
      end

      it 'hides old password field' do
        expect(page).not_to have_content('Old password')
      end
    end

    context 'when user has set password manually' do
      before do
        sign_in manual_user
        visit settings_account_path
      end

      it 'hides old password field' do
        expect(page).to have_content('Old password')
      end
    end
  end

  describe 'validate new password fields' do
    before do
      sign_in omniauth_user
      visit settings_account_path
    end

    context 'when form is empty' do
      it 'prompt user to fill the form' do
        click_button 'Update'
        expect(page).to have_content('fill in the form')
      end
    end

    context 'when password is too short' do
      it 'prompt user to fill the form' do
        fill_password_form('two', 'two')
        click_button 'Update'
        expect(page).to have_content('Password is too short')
      end
    end

    context 'when passwords do not match' do
      it 'prompts user to provide matching passwords' do
        fill_password_form('three', 'two')
        click_button 'Update'
        expect(page).to have_content('match')
      end
    end
  end

  describe 'validate old password fields' do
    before do
      sign_in manual_user
      visit settings_account_path
    end

    context 'when all fields are empty' do
      it 'prompt user to fill in the form' do
        click_button 'Update'
        expect(page).to have_content('fill in the form')
      end
    end

    context 'when all fields except old password are filled' do
      it 'prompt user to fill in the old password field' do
        fill_password_form('twentytwo', 'twentytwo')
        click_button 'Update'
        expect(page).to have_content('be blank')
      end
    end

    context 'when field has wrong password' do
      it 'prompt user to give the correct password' do
        fill_in 'user_current_password', with: 'wrongpassword'
        fill_password_form('twentytwo', 'twentytwo')
        click_button 'Update'
        expect(page).to have_content('Current password is invalid')
      end
    end
  end

  # describe 'sign in with omniauth' do
  #   OmniAuth.config.test_mode = true
  #
  #   Devise.omniauth_providers.each do |provider|
  #     before do
  #       Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
  #       Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[provider]
  #     end
  #
  #     context "when user signs in with #{provider}" do
  #       before { hash(provider) }
  #
  #       it 'logs in user' do
  #         page.find(:css, ".button.#{provider}").click
  #         post "/users/auth/#{provider}/callback"
  #         expect(response).to redirect_to(root_path)
  #       end
  #     end
  #   end
  # end

  describe 'delete account' do
    before do
      sign_in manual_user
      visit settings_account_path
    end

    it 'alert user to confirm' do
      page.find(:css, '.button.is-danger').click
      expect(page.alert).to have_content('Are you sure?')
    end
  end
end
