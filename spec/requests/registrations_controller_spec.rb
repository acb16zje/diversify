# frozen_string_literal: true

require 'rails_helper'

describe Users::RegistrationsController, type: :request do
  let(:user) { create(:user) }

  describe 'POST #create' do
    context 'when valid sign up details' do
      it {
        post '/users', params: {
          'user[email]': '123@email.com',
          'user[password]': '12345678'
        }
        expect(response).to have_http_status(:ok)
      }
    end

    context 'when invalid sign up details' do
      it {
        post '/users', params: {
          'user[email]': '1234',
          'user[password]': '1234'
        }
        expect(response).to have_http_status(:bad_request)
      }
    end

    context 'when email has been taken' do
      it {
        post '/users', params: {
          'user[email]': user.email,
          'user[password]': user.password
        }
        expect(response).to have_http_status(:bad_request)
      }
    end
  end

  describe 'PUT #update' do
    context 'when logged in' do
      before { sign_in user }

      context 'when valid inputs' do
        it {
          put '/users', params: {
            'user[current_password]': user.password,
            'user[password]': 'newPassword',
            'user[password_confirmation]': 'newPassword'
          }
          expect(response).to have_http_status(:ok)
        }
      end

      context 'when invalid current password' do
        it {
          put '/users', params: {
            'user[current_password]': 'invalidPass',
            'user[password]': 'newPassword',
            'user[password_confirmation]': 'newPassword'
          }
          expect(response).to have_http_status(:bad_request)
        }
      end

      context 'when invalid new password' do
        it {
          put '/users', params: {
            'user[current_password]': user.password,
            'user[password]': '',
            'user[password_confirmation]': ''
          }
          expect(response).to have_http_status(:bad_request)
        }
      end
    end

    context 'when not logged in' do
      it {
        put '/users', params: {
          'user[current_password]': user.password,
          'user[password]': 'newPassword',
          'user[password_confirmation]': 'newPassword'
        }
        expect(response).to redirect_to new_user_session_path
      }
    end

    context 'when OAuth user sets up password' do
      let(:omni_user) {
        create(:omniauth_user)
      }

      before { sign_in omni_user }

      it {
        put '/users', params: {
          'user[password]': 'newPassword',
          'user[password_confirmation]': 'newPassword'
        }
        expect(response).to have_http_status(:ok)
      }
    end
  end
end