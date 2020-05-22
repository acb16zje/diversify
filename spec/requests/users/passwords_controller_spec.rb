# frozen_string_literal: true

require 'rails_helper'

describe Users::PasswordsController, type: :request do
  let(:user) { create(:user) }

  describe 'POST #create' do
    subject(:request) { post user_password_path(params) }

    context 'with valid email' do
      let(:params) { { 'user[email]': user.email } }

      it_behaves_like 'returns 200 OK'
    end

    context 'with invalid email' do
      let(:params) { { 'user[email]': 'fake@email.com' } }

      it_behaves_like 'returns 400 Bad Request'
    end
  end

  describe 'PATCH #update' do
    subject(:request) { patch user_password_path(params) }

    let(:generate_token) do
      Devise.token_generator.generate(User, :reset_password_token)
    end

    before do
      user.reset_password_token = generate_token[1]
      user.reset_password_sent_at = Time.now.utc
      user.save
    end

    context 'with valid password' do
      let(:params) do
        {
          'user[reset_password_token]': generate_token[0],
          'user[password]': 'newPassword',
          'user[password_confirmation]': 'newPassword'
        }
      end

      it_behaves_like 'returns 200 OK'
    end

    context 'with invalid password' do
      let(:params) do
        {
          'user[reset_password_token]': generate_token[0],
          'user[password]': 'newPassword',
          'user[password_confirmation]': ''
        }
      end

      it_behaves_like 'returns 400 Bad Request'
    end

    context 'with invalid token' do
      let(:params) do
        {
          'user[reset_password_token]': '1234',
          'user[password]': 'newPassword',
          'user[password_confirmation]': 'newPassword'
        }
      end

      it_behaves_like 'returns 400 Bad Request'
    end
  end
end
