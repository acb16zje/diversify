# frozen_string_literal: true

require 'rails_helper'

describe Users::Settings::AccountsController, type: :request do

  describe 'POST #disconnect_omniauth' do
    before do
      sign_in omni_user
      delete disconnect_omniauth_settings_account_path, params: params
      follow_redirect!
    end

    Devise.omniauth_providers.each do |social|
      context "with valid #{social} account and no password" do
        let(:omni_user) { create(:omniauth_user, providers: [social]) }
        let(:params) { { provider: social } }

        it { expect(response.body).to include('Please set up a password') }
      end

      context "with valid #{social} account and password" do
        let(:omni_user) { create(:omniauth_user, :has_password, providers: [social]) }
        let(:params) { { provider: social } }

        it { expect(response.body).to include('Account Disconnected') }
      end
    end

    context 'with multiple valid social accounts' do
      let(:omni_user) { create(:omniauth_user, providers: Devise.omniauth_providers) }
      let(:params) { { provider: 'facebook' } }

      it { expect(response.body).to include('Account Disconnected') }
    end

    context 'with invalid social account' do
      let(:omni_user) { create(:user) }
      let(:params) { { provider: 'test' } }

      it { expect(response.body).to include('Invalid Request') }
    end
  end
end
