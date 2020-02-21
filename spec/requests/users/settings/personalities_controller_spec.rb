# frozen_string_literal: true

require 'rails_helper'

describe Users::Settings::PersonalitiesController, type: :request do
  let(:user) { create(:user) }
  let(:personality) { create(:personality) }
  let(:user_personality) { create(:user,:personality) }
  describe 'GET #show' do
    context 'when signed in' do
      before { sign_in user }

      it {
        get settings_personality_path
        expect(response).to have_http_status(:ok)
      }
    end

    context 'when signed out' do

      it {
        get settings_personality_path
        expect(response).to redirect_to new_user_session_path
      }
    end
  end

  describe 'PATCH #update' do
    context 'when initial selection' do
      before { sign_in user_personality }

      it {
        patch settings_personality_path,
          params: {
            personality: {
              mind: 'i',
              energy: 's',
              nature: 'f',
              tactic: 'j'
            }
          }
        expect(response).to have_http_status(:ok)
      }
    end

    context 'when valid input' do
      before do
        sign_in user
        personality
      end

      it {
        patch settings_personality_path,
          params: {
            personality: {
              mind: 'i',
              energy: 's',
              nature: 'f',
              tactic: 'j'
            }
          }
        expect(response).to have_http_status(:ok)
      }
    end

    context 'when invalid input' do
      before do
        sign_in user
        personality
      end

      it {
        patch settings_personality_path,
          params: {
            personality: {
              mind: 'i',
              energy: 's',
              nature: 'f',
              tactic: ''
            }
          }
        expect(response).to have_http_status(:unprocessable_entity)
      }

      it {
        patch settings_personality_path,
          params: {
            personality: {
              mind: 'e',
              energy: 's',
              nature: 'f',
              tactic: 'j'
            }
          }
        expect(response).to have_http_status(:unprocessable_entity)
      }
    end
  end
end
