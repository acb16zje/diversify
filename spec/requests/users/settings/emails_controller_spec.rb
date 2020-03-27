# frozen_string_literal: true

require 'rails_helper'

describe Users::Settings::EmailsController, type: :request do
  describe 'POST #subscribe' do
    subject(:request) { post subscribe_settings_emails_path }

    let(:user) { create(:user) }

    it_behaves_like 'not accessible to unauthenticated users'

    context 'when logged in' do
      before do
        sign_in user
        request
        follow_redirect!
      end

      it { expect(response.body).to include('Newsletter Subscribed') }
    end
  end

  describe 'POST #unsubscribe' do
    subject(:request) { post unsubscribe_settings_emails_path }

    let(:newsletter_user) { create(:user, :newsletter) }

    it_behaves_like 'not accessible to unauthenticated users'

    context 'when logged in' do
      before do
        sign_in newsletter_user
        request
        follow_redirect!
      end

      it { expect(response.body).to include('Newsletter Unsubscribed') }
    end
  end
end
