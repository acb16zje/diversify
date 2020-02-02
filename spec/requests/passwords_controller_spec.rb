# frozen_string_literal: true

require 'rails_helper'

describe Users::PasswordsController, type: :request do
  let(:user) { create(:user) }

  describe 'POST #create' do
    context 'when valid email' do
      it {
        post '/users/password', params: {
          'user[email]': user.email,
          authenticity_token: Devise.friendly_token
        }
        expect(response).to have_http_status(:ok)
      }
    end

    context 'when invalid email' do
      it {
        post '/users/password', params: {
          'user[email]': 'fake@email.com',
          authenticity_token: Devise.friendly_token
        }
        expect(response).to have_http_status(:bad_request)
      }
    end
  end

  describe 'PUT #update' do
    let (:generate_token) { Devise.token_generator.generate(User, :reset_password_token)}
    
    before do
      @raw, hashed = generate_token
      user.reset_password_token = hashed
      user.reset_password_sent_at = Time.now.utc
      user.save
    end

    context 'when valid password' do
      it {
        put '/users/password', params: {
          'user[reset_password_token]': @raw,
          'user[password]': 'newPassword',
          'user[password_confirmation]': 'newPassword',
          authenticity_token: Devise.friendly_token
        }
        expect(response).to have_http_status(:ok)
      }
    end

    context 'when invalid password' do
      it {
        put '/users/password', params: {
          'user[reset_password_token]': @raw,
          'user[password]': 'newPassword',
          'user[password_confirmation]': '',
          authenticity_token: Devise.friendly_token
        }
        expect(response).to have_http_status(:bad_request)
      }
    end

    context 'when invalid token' do
      it {
        put '/users/password', params: {
          'user[reset_password_token]': '1234',
          'user[password]': 'newPassword',
          'user[password_confirmation]': 'newPassword',
          authenticity_token: Devise.friendly_token
        }
        expect(response).to have_http_status(:bad_request)
      }
    end
      
  end
end
