# frozen_string_literal: true

require 'rails_helper'

describe Users::Settings::ProfilesController, type: :request do
  let(:user) { create(:user) }

  describe 'GET #show' do
    context 'when signed in' do
      before { sign_in user }

      it 'allows user to edit own profile' do
        get settings_profile_path

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when signed out' do
      it 'redirects to sign in page' do
        get settings_profile_path

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    before { sign_in user }

    context 'with valid birthdate' do
      it {
        patch settings_profile_path, params: { user: { birthdate: '1/1/1970' } }

        expect(response).to have_http_status(:ok)
      }
    end

    context 'with invalid birthdate' do
      it 'returns HTTP 400 for birthdate >= created_at' do
        patch settings_profile_path, params: {
          user: { birthdate: user.created_at }
        }
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns HTTP 400 for age < 6' do
        patch settings_profile_path, params: {
          user: { birthdate: Time.current - 1.year }
        }
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns HTTP 400 for age > 80' do
        patch settings_profile_path, params: { user: { birthdate: '1/1/1800' } }

        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'DELETE #remove_avatar' do
    let(:user_with_avatar) { create(:user, :with_avatar) }

    context 'with avatar' do
      before { sign_in user_with_avatar }

      it {
        delete remove_avatar_settings_profile_path
        expect(response).to redirect_to(settings_profile_path)
      }
    end

    context 'without avatar' do
      before { sign_in user }

      it {
        delete remove_avatar_settings_profile_path
        expect(response).to have_http_status(:not_found)
      }
    end
  end
end
