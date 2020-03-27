# frozen_string_literal: true

require 'rails_helper'

describe Users::Settings::ProfilesController, type: :request do
  let(:user) { create(:user) }

  describe 'GET #show' do
    subject(:request) { get settings_profile_path }

    it_behaves_like 'accessible to authenticated users'
    it_behaves_like 'not accessible to unauthenticated users'
  end

  describe 'PATCH #update' do
    subject(:request) { patch settings_profile_path, params: params }

    before { sign_in user }

    context 'with empty birthdate' do
      let(:params) { { user: { birthdate: '' } } }

      it_behaves_like 'returns 200 OK'
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

      it_behaves_like 'returns 200 OK'
    end

    context 'with invalid request syntax' do
      let(:params) { { user: { birthdate: '1/1/1970' } } }

      it_behaves_like 'returns 400 Bad Request'
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

      it_behaves_like 'returns 400 Bad Request'
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

      it_behaves_like 'returns 400 Bad Request'
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

      it_behaves_like 'returns 400 Bad Request'
    end
  end

  describe 'DELETE #remove_avatar' do
    subject(:request) { delete remove_avatar_settings_profile_path }

    let(:user_with_avatar) { create(:user, :with_avatar) }

    it_behaves_like 'not accessible to unauthenticated users'

    context 'when signed in with avatar' do
      before { sign_in user_with_avatar }

      it_behaves_like 'redirects to', :settings_profile_path
    end

    context 'when signed in without avatar' do
      before { sign_in user }

      it_behaves_like 'returns 404 Not Found'
    end
  end
end
