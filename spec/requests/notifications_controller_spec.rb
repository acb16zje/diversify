# frozen_string_literal: true

require 'rails_helper'

describe NotificationsController, type: :request do
  let(:user) { create(:user) }

  describe '#GET index' do
    subject(:request) { get notifications_path }

    it_behaves_like 'accessible to authenticated users'
    it_behaves_like 'not accessible to unauthenticated users'
  end

  describe '#GET open' do
    subject(:request) { get open_notification_path(notification) }

    context 'when not logged in' do
      let(:notification) { create(:notification) }

      it_behaves_like 'not accessible to unauthenticated users'
    end

    context 'when owns notification' do
      let(:notification) { create(:notification, user: user) }

      before { sign_in user }

      it { expect(request).to redirect_to notification.notifier }
    end

    context 'when not owner' do
      let(:notification) { create(:notification) }

      before { sign_in user }

      it_behaves_like 'returns 404 Not Found'
    end
  end

  describe '#POST open_all' do
    subject(:request) { post open_all_notifications_path }

    before { create(:notification, user: user) }

    it_behaves_like 'accessible to authenticated users'
    it_behaves_like 'not accessible to unauthenticated users'
  end
end
