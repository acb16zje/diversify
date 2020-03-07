# frozen_string_literal: true

require 'rails_helper'

describe 'New Session > User', :js, type: :system do
  let(:user) { create(:user) }

  before do
    visit new_user_session_path
  end

  describe 'show sign in page' do
    it do
      expect(page).to have_content('Sign in to Diversify')
    end
  end

  describe 'sign in user' do
    it 'can request session' do
      fill_form(user.email, user.password)
      click_button 'Sign in'
      expect(page).to have_content('Introduction')
    end
  end

  describe 'validate user' do
    let(:email) do
      find('#user_email').native.attribute('validationMessage')
    end
    let(:password) do
      find('#user_password').native.attribute('validationMessage')
    end

    context 'when wrong password' do
      it 'alerts user error' do
        fill_form('admin@email.com', 'wrong password')
        click_button 'Sign in'
        expect(page).to have_content('Invalid email')
      end
    end

    context 'when email missing @' do
      it 'prompts user to complete email' do
        fill_form('admin', '')
        click_button 'Sign in'
        expect(email).to have_content('is missing an')
      end
    end

    context 'when email incomplete after @' do
      it 'prompt user to complete email' do
        fill_form('admin@', '')
        click_button 'Sign in'
        expect(email).to have_content('Please enter a part following')
      end
    end

    context 'when email is blank' do
      it 'prompt user to fill in email' do
        click_button 'Sign in'
        expect(email).to have_content('Please fill in this field')
      end
    end

    context 'when password is blank' do
      it 'prompt user to fill in password' do
        fill_form('admin@email.com', '')
        click_button 'Sign in'
        expect(password).to have_content('Please fill in this field')
      end
    end
  end

  describe 'sign in with omniauth' do
    OmniAuth.config.test_mode = true

    Devise.omniauth_providers.each do |provider|
      before do
        Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[provider]
      end

      context "when user signs in with #{provider}" do
        before { hash(provider) }

        it 'logs in user' do
          page.find(:css, ".button.#{provider}").click
          post "/users/auth/#{provider}/callback"
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  describe 'can access other authentication pages' do
    context 'when redirecting to sign up page' do
      it 'redirects to sign up' do
        click_link 'Create an account'
        expect(page).to have_content('Create your account')
      end
    end

    context 'when redirecting to password recovery page' do
      it 'redirects to password recovery page' do
        click_link 'Forgot password?'
        expect(page).to have_content('Forgot your password?')
      end
    end
  end
end
