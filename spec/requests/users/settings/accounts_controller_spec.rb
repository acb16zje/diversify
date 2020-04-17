# frozen_string_literal: true

require 'rails_helper'

describe Users::Settings::AccountsController, type: :request do
  describe 'DELETE #disconnect_omniauth' do
    subject(:request) { delete disconnect_omniauth_settings_account_path, params: params }

    before do |test|
      sign_in omni_user
      request
      follow_redirect! unless test.metadata[:no_redirect]
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

    context 'with invalid social account', :no_redirect do
      let(:omni_user) { create(:omniauth_user, providers: ['google']) }
      let(:params) { { provider: 'invalid' } }

      it { expect(response.body).to include('Not Found') }
    end
  end

  describe 'PUT #reset_password' do
    subject(:request) { put reset_password_settings_account_path }

    it_behaves_like 'not accessible to unauthenticated users'

    describe 'when signed in' do
      before { sign_in create(:user) }

      it_behaves_like 'redirects to', :settings_account_path
    end
  end
end
