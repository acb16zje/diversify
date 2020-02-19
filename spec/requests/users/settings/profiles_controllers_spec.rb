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

    shared_examples 'returns Bad Request' do
      it {
        patch settings_profile_path, params: params

        expect(response).to have_http_status(:bad_request)
      }
    end

    context 'with empty birthdate' do
      it {
        patch settings_profile_path, params: { user: { birthdate: '' } }

        expect(response).to have_http_status(:ok)
      }
    end

    context 'with invalid request syntax' do
      let(:params) { { user: { birthdate: '1/1/1970' } } }

      it_behaves_like 'returns Bad Request'
    end

    context 'when age between 6 and 80' do
      let(:params) do
        {
          user: {
            'birthdate(1i)': 1990,
            'birthdate(2i)': 1,
            'birthdate(3i)': 1
          }
        }
      end

      it {
        patch settings_profile_path, params: params

        expect(response).to have_http_status(:ok)
      }
    end

    context 'when birthdate >= created_at' do
      let(:params) do
        {
          user: {
            'birthdate(1i)': user.created_at.year,
            'birthdate(2i)': user.created_at.month,
            'birthdate(3i)': user.created_at.day
          }
        }
      end

      it_behaves_like 'returns Bad Request'
    end

    context 'when age < 6' do
      let(:params) do
        {
          user: {
            'birthdate(1i)': Time.current.year - 5,
            'birthdate(2i)': 1,
            'birthdate(3i)': 1
          }
        }
      end

      it_behaves_like 'returns Bad Request'
    end

    context 'when age > 80' do
      let(:params) do
        {
          user: {
            'birthdate(1i)': Time.current.year - 81,
            'birthdate(2i)': 1,
            'birthdate(3i)': 1
          }
        }
      end

      it_behaves_like 'returns Bad Request'
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
