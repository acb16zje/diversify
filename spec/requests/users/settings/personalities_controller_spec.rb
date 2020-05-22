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
    subject(:request) { patch settings_personality_path(params) }

    before { create(:personality) }

    context 'with valid input' do
      let(:params) do
        { personality: { mind: 'I', energy: 'S', nature: 'F', tactic: 'J' } }
      end

      it_behaves_like 'accessible to authenticated users'
      it_behaves_like 'not accessible to unauthenticated users'
    end

    context 'with invalid input' do
      before { sign_in user }

      let(:params) do
        { personality: { mind: '', energy: '', nature: '', tactic: '' } }
      end

      it_behaves_like 'returns 422 Unprocessable Entity'
    end
  end
end
