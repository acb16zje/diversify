# frozen_string_literal: true

require 'rails_helper'

describe Users::Settings::AccountsController, type: :request do

  describe 'POST #disconnect_omniauth' do
    Devise.omniauth_providers.each do |social|
      context "with valid #{social} account and no password" do
        let(:omni_user) { create(:omniauth_user, providers: [social]) }

        before { sign_in omni_user }

        it {
          delete disconnect_omniauth_settings_account_path,
                 params: { provider: social }
          follow_redirect!
          expect(response.body).to include('Please set up a password')
        }
      end

      context "with valid #{social} account and password" do
        let(:omni_user) do
          create(:omniauth_user, :has_password, providers: [social])
        end

        before { sign_in omni_user }

        it {
          delete disconnect_omniauth_settings_account_path,
                 params: { provider: social }
          follow_redirect!
          expect(response.body).to include('Account Disconnected')
        }
      end
    end

    context 'with multiple valid social accounts' do
      let(:omni_user) do
        create(:omniauth_user, providers: Devise.omniauth_providers)
      end

      before { sign_in omni_user }

      it {
        delete disconnect_omniauth_settings_account_path,
               params: { provider: 'facebook' }
        follow_redirect!
        expect(response.body).to include('Account Disconnected')
      }
    end

    context 'with invalid social account' do
      let(:user) { create(:user) }

      before { sign_in user }

      it {
        delete disconnect_omniauth_settings_account_path,
               params: { provider: 'test' }
        follow_redirect!
        expect(response.body).to include('Invalid Request')
      }
    end
  end
end
