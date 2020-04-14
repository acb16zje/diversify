# frozen_string_literal: true

require 'rails_helper'

describe UsersController, type: :request do
  describe 'GET #show' do
    subject(:request) { get user_path(user) }

    let(:user) { create(:user) }

    it_behaves_like 'accessible to authenticated users'
    it_behaves_like 'accessible to unauthenticated users'

    context 'when user does not exist' do
      subject(:request) { get user_path(id: 0) }

      it_behaves_like 'returns 404 Not Found'
    end
  end
end
