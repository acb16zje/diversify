# frozen_string_literal: true

require 'rails_helper'
require_relative 'user_helper'

describe 'new Registration > User', :js, type: :system do
  let(:user) { create(:user) }

  before do
    visit new_user_registration_path
  end

  describe 'show sign up page' do
    it do
      expect(page).to have_content('Create your account')
    end
  end

  describe 'sign up user' do
    it 'can register user' do
      click_button 'Sign up'
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

    context 'when using a duplicate email address' do
      it 'alerts user error' do
        fill_form(user.email, user.password)
        click_button 'Sign up'
        expect(page).to have_content('has already been taken')
      end
    end

    context 'when email missing @' do
      it 'prompts user to complete email' do
        fill_form('admin', '')
        click_button 'Sign up'
        expect(email).to have_content('is missing an')
      end
    end

    context 'when email incomplete after @' do
      it 'prompt user to complete email' do
        fill_form('email@', '')
        click_button 'Sign up'
        expect(email).to have_content('Please enter a part following')
      end
    end

    context 'when email is blank' do
      it 'prompt user to fill in email' do
        click_button 'Sign up'
        expect(email).to have_content('Please fill in this field')
      end
    end

    context 'when password is blank' do
      it 'prompt user to fill in password' do
        fill_in 'user_email', with: 'admin@email.com'
        click_button 'Sign up'
        expect(password).to have_content('Please fill in this field')
      end
    end

    context 'when password is short' do
      it 'prompt user to use longer password' do
        fill_in 'user_email', with: 'newuser@email.com'
        fill_in 'user_password', with: 'pass'
        click_button 'Sign up'
        expect(page).to have_content('minimum is 6 characters')
      end
    end
  end

  describe 'can access other authentication pages' do
    it 'redirects to sign in' do
      click_link 'Sign in'
      expect(page).to have_content('Sign in to Diversify')
    end
  end
end
