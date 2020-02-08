# frozen_string_literal: true

require 'rails_helper'

describe Users::SessionsController, type: :request do
  let(:user) { create(:user) }

  describe 'POST #sign_in' do
    context 'with valid sign in' do
      it 'sign in and redirect to home page' do
        post user_session_path,
             params: { user: { email: user.email, password: user.password } }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid sign in params' do
      it 'sends error' do
        post user_session_path,
             params: { user: { email: 'fake@email.com', password: 'fake123' } }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with no sign in params' do
      it 'sends error' do
        post user_session_path
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
