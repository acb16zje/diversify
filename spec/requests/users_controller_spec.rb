# frozen_string_literal: true

require 'rails_helper'

describe UsersController, type: :request do
  let(:user) { create(:user) }

  describe 'authorisations' do
    before { sign_in user }

    it { expect { get user_path(user) }.to be_authorized_to(:show?, user) }
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
end
