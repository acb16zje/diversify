# frozen_string_literal: true

require 'rails_helper'

describe Users::Settings::EmailsController, type: :request do
  let(:user) { create(:user) }
  let(:newsletter_user) { create(:user, :newsletter) }

  describe 'POST #subscribe' do
    context 'when logged in' do
      before { sign_in user }

      it {
        post subscribe_settings_emails_path
        follow_redirect!
        expect(response.body).to include('Newsletter Subscribed')
      }
    end

    context 'when not logged in' do
      it {
        post subscribe_settings_emails_path
        expect(response).to redirect_to new_user_session_path
      }
    end
  end

  describe 'POST #unsubscribe' do
    context 'when logged in' do
      before { sign_in newsletter_user }

      it {
        post unsubscribe_settings_emails_path
        follow_redirect!
        expect(response.body).to include('Newsletter Unsubscribed')
      }
    end

    context 'when not logged in' do
      it {
        post unsubscribe_settings_emails_path
        expect(response).to redirect_to new_user_session_path
      }
    end
  end
end
