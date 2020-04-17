# frozen_string_literal: true

require 'rails_helper'

describe NotificationsController, type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe 'GET #index' do
    subject(:request) { get notifications_path }

    it_behaves_like 'returns 404 Not Found'
  end

  describe 'GET #index XHR' do
    subject(:request) { get notifications_path, xhr: true }

    it_behaves_like 'returns JSON response'
  end

  describe 'DELETE #destroy' do
    subject(:request) { delete notification_path(notification) }

    let(:notification) { create(:notification, user: user) }

    it_behaves_like 'returns 200 OK'
  end

  describe 'PATCH #read' do
    subject(:request) { patch read_notification_path(notification) }

    context 'when user is notification owner' do
      let(:notification) { create(:notification, user: user) }

      it_behaves_like 'returns 200 OK'
    end

    context 'when user is not notification owner' do
      let(:notification) { create(:notification) }

      it_behaves_like 'returns 404 Not Found'
    end
  end

  describe 'PATCH #unread' do
    subject(:request) { patch unread_notification_path(notification) }

    context 'when user is notification owner' do
      let(:notification) { create(:notification, user: user) }

      it_behaves_like 'returns 200 OK'
    end

    context 'when user is not notification owner' do
      let(:notification) { create(:notification) }

      it_behaves_like 'returns 404 Not Found'
    end
  end

  describe 'PATCH #read_all' do
    subject(:request) { patch read_all_notifications_path }

    it_behaves_like 'returns 200 OK'
  end
end
