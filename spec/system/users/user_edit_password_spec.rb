# frozen_string_literal: true

require 'rails_helper'

describe 'New Password > Password', :js, type: :system do
  before { visit new_user_password_path }

  let(:user) { create(:user) }

  describe 'show password reset page' do
    it do
      expect(page).to have_content('Reset Password')
    end
  end

  describe 'can submit email' do
    it do
      fill_in 'user_email', with: user.email
      click_button 'Send reset password instructions'
    end
  end

  describe 'validate user email' do
    let(:email) do
      find('#user_email').native.attribute('validationMessage')
    end

    context 'when email missing @' do
      it 'prompts user to complete email' do
        fill_in 'user_email', with: 'admin'
        click_button 'Send reset password instructions'
        expect(email).to have_content('is missing an')
      end
    end

    context 'when email incomplete after @' do
      it 'prompt user to complete email' do
        fill_in 'user_email', with: 'admin@'
        click_button 'Send reset password instructions'
        expect(email).to have_content('Please enter a part following')
      end
    end

    context 'when email is blank' do
      it 'prompt user to fill in email' do
        click_button 'Send reset password instructions'
        expect(email).to have_content(/Please fill (in|out) this field/)
      end
    end

    context 'when email cannot be found' do
      it 'prompt user email that has been registered' do
        fill_in 'user_email', with: 'newemail@email.com'
        click_button 'Send reset password instructions'
        expect(page).to have_content('Email not found')
      end
    end
  end
end
