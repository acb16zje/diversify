# frozen_string_literal: true

require 'rails_helper'
require_relative 'user_helper'

describe 'new Session > User', :js, type: :system do
  let(:user) do
    User.create(
      name: 'User',
      email: 'user@email.com',
      password: 'password',
      admin: false
    )
  end

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

  describe 'sign in with omniauth_providers' do
    context 'when signing in with google' do
      it 'allows user to sign in with google' do
        page.find(:css, '.button.google_oauth2').click
      end
    end

    # context 'when signing in with facebook' do
    #   it 'allows user to sign in with facebook' do
    #     page.find(:css, '.facebook.button').click
    #   end
    # end
    #
    # context 'when signing in with Twitter' do
    #   it 'allows user to sign in with Twitter' do
    #     page.find(:css, '.twitter.button').click
    #   end
    # end
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
