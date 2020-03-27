# frozen_string_literal: true

require 'rails_helper'

describe Users::Settings::PersonalitiesController, type: :request do
  let(:user) { create(:user) }

  describe 'GET #show' do
    subject(:request) { get settings_personality_path }

    it_behaves_like 'accessible to authenticated users'
    it_behaves_like 'not accessible to unauthenticated users'
  end

  describe 'PATCH #update' do
    subject(:request) { patch settings_personality_path, params: params }

    let(:personality) { create(:personality) }
    let(:user_personality) { create(:user, :personality) }

    context 'with initial selection' do
      before { sign_in user_personality }

      let(:params) do
        { personality: { mind: 'i', energy: 's', nature: 'f', tactic: 'j' } }
      end

      it_behaves_like 'returns 200 OK'
    end

    context 'with valid input' do
      before { personality }

      let(:params) do
        { personality: { mind: 'i', energy: 's', nature: 'f', tactic: 'j' } }
      end

      it_behaves_like 'accessible to authenticated users'
      it_behaves_like 'not accessible to unauthenticated users'
    end

    context 'with invalid input' do
      before do
        sign_in user
        personality
      end

      let(:params) do
        { personality: { mind: '', energy: '', nature: '', tactic: '' } }
      end

      it_behaves_like 'returns 422 Unprocessable Entity'
    end
  end
end
