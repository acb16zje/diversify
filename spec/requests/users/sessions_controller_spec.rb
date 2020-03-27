# frozen_string_literal: true

require 'rails_helper'

describe Users::SessionsController, type: :request do
  let(:user) { create(:user) }

  describe 'POST #sign_in' do
    subject(:request) { post user_session_path, params: params }

    context 'with valid sign in' do
      let(:params) { { user: { email: user.email, password: user.password } } }

      it_behaves_like 'returns 200 OK'
    end

    context 'with invalid sign in params' do
      let(:params) do
        { user: { email: 'fake@email.com', password: 'fake123' } }
      end

      it_behaves_like 'returns 401 Unauthorized'
    end

    context 'with no sign in params' do
      let(:params) { {} }

      it_behaves_like 'returns 401 Unauthorized'
    end
  end
end
