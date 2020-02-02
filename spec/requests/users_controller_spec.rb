# frozen_string_literal: true

require 'rails_helper'

SOCIAL_ACCOUNTS = %w[
  facebook
  google_oauth2
  twitter
].freeze

describe UsersController, type: :request do
  let(:user) { create(:user) }

  describe 'authorisations' do
    before { sign_in user }

    it { expect { get user_path(user) }.to be_authorized_to(:show?, user) }
    it { expect { get edit_user_path(user) }.to be_authorized_to(:edit?, user) }
  end

  describe 'GET #show' do
    shared_examples 'shows user profile' do
      it {
        get user_path(user)
        expect(response).to have_http_status(:ok)
      }
    end

    context 'when signed in' do
      before { sign_in user }

      it_behaves_like 'shows user profile'
    end

    context 'when signed out' do
      it_behaves_like 'shows user profile'
    end

    context 'when user does not exist' do
      it 'shows 404' do
        get user_path(id: 0)

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET #settings' do
    context 'when signed in' do
      before { sign_in user }

      it 'shows user settings page' do
        get settings_users_path

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when signed out' do
      it 'redirects to sign in page' do
        get settings_users_path

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #disconnect_omniauth' do
    SOCIAL_ACCOUNTS.each do |social|
      context "with valid #{social} account and no password" do
        let(:omni_user) do
          create(:omniauth_user, providers: [social], no_password: true)
        end

        before { sign_in omni_user }

        it {
          delete disconnect_omniauth_users_path, params: { provider: social }
          expect(response).to have_http_status(:bad_request)
        }
      end

      context "with valid #{social} account and password" do
        let(:omni_user) { create(:omniauth_user, providers: [social]) }

        before { sign_in omni_user }

        it {
          delete disconnect_omniauth_users_path, params: { provider: social }
          expect(response).to have_http_status(:ok)
        }
      end
    end

    context 'with multiple valid social accounts' do
      let(:omni_user) {
        create(:omniauth_user, providers: SOCIAL_ACCOUNTS, no_password: true)
      }

      before { sign_in omni_user }

      it {
        delete disconnect_omniauth_users_path, params: { provider: 'facebook' }
        expect(response).to have_http_status(:ok)
      }
    end

    context 'with invalid social account' do
      before { sign_in user }

      it {
        delete disconnect_omniauth_users_path, params: { provider: 'test' }
        expect(response).to have_http_status(:bad_request)
      }
    end
  end
end
