# frozen_string_literal: true

require 'rails_helper'

describe UsersController do
  let(:user) { create(:user) }

  describe 'GET #show' do
    context 'when logged in' do
      before do
        sign_in user
      end

      it 'renders the show template' do
        get :show, params: { id: user.id }

        expect(response).to render_template('show')
      end
    end

    context 'when logged out' do
      it 'redirects me to login page' do
        get :show, params: { id: user.id }

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user does not exist' do
      it 'shows 404' do
        get :show, params: { id: 0 }

        expect(response.status).to eq(302)
      end
    end
  end

  # describe 'GET #settings' do
  #   context 'GET '
  # end
end
