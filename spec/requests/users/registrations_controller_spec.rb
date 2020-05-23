# frozen_string_literal: true

require 'rails_helper'

describe Users::RegistrationsController, type: :request do
  let(:user) { create(:user) }

  describe 'POST #create' do
    subject(:request) { post user_registration_path(params) }

    context 'with valid sign up details' do
      let(:params) { { 'user[email]': '123@email.com', 'user[password]': '12345678' } }

      it_behaves_like 'returns 200 OK'
    end

    context 'with invalid sign up details' do
      let(:params) { { 'user[email]': '1234', 'user[password]': '1234' } }

      it_behaves_like 'returns 400 Bad Request'
    end

    context 'when email has been taken' do
      let(:params) { { 'user[email]': user.email, 'user[password]': user.password } }

      it_behaves_like 'returns 400 Bad Request'
    end
  end

  describe 'PATCH #update' do
    subject(:request) { patch user_registration_path(params) }

    context 'when valid inputs' do
      let(:params) do
        {
          'user[current_password]': user.password,
          'user[password]': 'newPassword',
          'user[password_confirmation]': 'newPassword'
        }
      end

      it_behaves_like 'accessible to authenticated users'
      it_behaves_like 'not accessible to unauthenticated users'
    end

    context 'when invalid current password' do
      before { sign_in user }

      let(:params) do
        {
          'user[current_password]': 'invalidPass',
          'user[password]': 'newPassword',
          'user[password_confirmation]': 'newPassword'
        }
      end

      it_behaves_like 'returns 400 Bad Request'
    end

    context 'when invalid new password' do
      before { sign_in user }

      let(:params) do
        {
          'user[current_password]': user.password,
          'user[password]': '',
          'user[password_confirmation]': ''
        }
      end

      it_behaves_like 'returns 400 Bad Request'
    end

    context 'when OAuth user sets up password' do
      let(:params) do
        {
          'user[password]': 'newPassword',
          'user[password_confirmation]': 'newPassword'
        }
      end

      before { sign_in create(:omniauth_user) }

      it_behaves_like 'returns 200 OK'
    end
  end

  describe 'DELETE #destroy' do
    subject(:request) { delete user_registration_path }

    before { sign_in user }

    it_behaves_like 'redirects to', :root_path

    it 'deletes the user' do
      request
      expect(User.all).not_to include(user)
    end
  end
end
