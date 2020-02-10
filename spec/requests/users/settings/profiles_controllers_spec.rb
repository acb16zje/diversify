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

    context 'with valid input' do
      it {
        patch settings_profile_path, params: {
          user: {
            name: user.name,
            birthdate: '1/1/1970'
          }
        }

        expect(response).to have_http_status(:ok)
      }
    end

    context 'with invalid input' do
      it {
        patch settings_profile_path, params: {
          user: {
            name: 'name',
            birthdate: '1/1/2020'
          }
        }

        expect(response).to have_http_status(:bad_request)
      }
    end
  end

end
