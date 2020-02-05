# frozen_string_literal: true

require 'rails_helper'

SOCIAL_ACCOUNTS = %w[
  facebook
  twitter
  google_oauth2
].freeze

describe Users::OmniauthCallbacksController, type: :request do
  let(:user) { create(:user) }
  OmniAuth.config.test_mode = true

  SOCIAL_ACCOUNTS.each do |provider|
    describe "sign in with #{provider}" do
      context 'with valid account' do
        before do
          hash(provider)
          Rails.application.env_config['devise.mapping'] = Devise.mappings[:user] # If using Devise
          Rails.application.env_config['omniauth.auth'] =
            OmniAuth.config.mock_auth[to_symbol(provider)]
        end

        it {
          get "/users/auth/#{provider}"
          follow_redirect!
          expect(response).to redirect_to(root_path)
        }
      end 

      context 'with taken email' do
        let(:test_user) do
          create(:omniauth_user, providers: ['test'])
        end

        before do
          hash(provider,test_user.email)
          Rails.application.env_config['devise.mapping'] = Devise.mappings[:user] # If using Devise
          Rails.application.env_config['omniauth.auth'] =
            OmniAuth.config.mock_auth[to_symbol(provider)]
        end

        it {
          get "/users/auth/#{provider}"
          follow_redirect!
          expect(response).to redirect_to(new_user_registration_path)
        }
      end
    end

    describe "connect with #{provider}" do
      before {
        sign_in user
      }

      context 'with valid account' do
        before do
          hash(provider)
          Rails.application.env_config['devise.mapping'] = Devise.mappings[:user] # If using Devise
          Rails.application.env_config['omniauth.auth'] =
            OmniAuth.config.mock_auth[to_symbol(provider)]
          end

        it {
          get "/users/auth/#{provider}"
          follow_redirect!
          follow_redirect!
          expect(response.body).to include('Account Connected')
        }
      end

      context 'with taken account' do
        let(:omni_user) do
          create(:omniauth_user, providers: [provider])
        end

        before do
          hash(provider, omni_user.email)
          Rails.application.env_config['devise.mapping'] = Devise.mappings[:user] # If using Devise
          Rails.application.env_config['omniauth.auth'] =
            OmniAuth.config.mock_auth[to_symbol(provider)]
        end

        it {
          get "/users/auth/#{provider}"
          follow_redirect!
          follow_redirect!
          expect(response.body).to include('Account has been taken')
        }
      end
    end
  end
end