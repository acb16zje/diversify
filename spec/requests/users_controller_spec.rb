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

  describe 'GET #timeline' do
    subject(:request) { get timeline_user_path(user, month: -1), xhr: true }

    let(:user) { create(:user) }

    before { create(:activity, user: user) }

    it_behaves_like 'accessible to authenticated users'
    it_behaves_like 'accessible to unauthenticated users'

    context 'when invalid input' do
      subject(:request) { get timeline_user_path(user, month: 'foo'), xhr: true }

      before { request }

      it { expect(response.body).to include('End of Timeline') }
    end

    context 'when values left' do
      subject(:request) { get timeline_user_path(user, month: 999), xhr: true }

      before { request }

      it { expect(response.body).to include('End of Timeline') }
    end
  end
end
