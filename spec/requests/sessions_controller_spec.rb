# frozen_string_literal: true

require 'rails_helper'

describe Users::SessionsController, type: :request do
  let(:user) { create(:user) }

  describe 'POST #sign_in' do
    context 'with valid sign in' do
      it 'sign in and redirect to home page' do
        post user_session_path('user[email]': user.email,
                               'user[password]': user.password,
                               authenticity_token: Devise.friendly_token)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid sign in' do
      it 'sends error' do
        post user_session_path('user[email]': 'fake@email.com',
                               'user[password]': 'fake123',
                               authenticity_token: Devise.friendly_token)
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end