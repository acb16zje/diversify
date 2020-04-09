# frozen_string_literal: true

require 'rails_helper'

describe NewslettersController, type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }
  let(:newsletter) { create(:newsletter) }

  describe 'authorisations' do
    before { sign_in admin }

    describe '#index' do
      subject(:request) { get newsletters_path }

      it { expect { request }.to be_authorized_to(:manage?, Newsletter) }
    end

    describe '#new' do
      subject(:request) { get new_newsletter_path }

      it { expect { request }.to be_authorized_to(:manage?, Newsletter) }
    end

    describe '#show' do
      subject(:request) { get newsletter_path(newsletter) }

      it { expect { request }.to be_authorized_to(:manage?, Newsletter) }
    end

    describe '#create' do
      subject(:request) { post newsletters_path(newsletter) }

      it { expect { request }.to be_authorized_to(:manage?, Newsletter) }
    end

    describe '#subscribers' do
      subject(:request) { get subscribers_newsletters_path }

      it { expect { request }.to be_authorized_to(:manage?, Newsletter) }
    end
  end

  describe 'GET #index' do
    subject(:request) { get newsletters_path }

    it_behaves_like 'accessible to admin users'
    it_behaves_like 'not accessible to non-admin users'
  end

  describe 'GET #new' do
    subject(:request) { get new_newsletter_path }

    it_behaves_like 'accessible to admin users'
    it_behaves_like 'not accessible to non-admin users'
  end

  describe 'POST #create' do
    subject(:request) { post newsletters_path, params: params }

    context 'with valid inputs' do
      let(:params) do
        { newsletter: { title: newsletter.title, content: newsletter.content } }
      end

      it_behaves_like 'accessible to admin users'
      it_behaves_like 'not accessible to non-admin users'
    end

    context 'with missing params as admin' do
      let(:params) do
        { newsletter: { title: '', content: newsletter.content } }
      end

      before { sign_in admin }

      it_behaves_like 'returns 422 Unprocessable Entity'
    end
  end

  describe 'GET #show' do
    subject(:request) { get newsletter_path(params) }

    context 'with valid newsletter' do
      let(:params) { newsletter }

      it_behaves_like 'accessible to admin users'
      it_behaves_like 'not accessible to non-admin users'
    end

    context 'with invalid newsletter as admin' do
      let(:params) { 0 }

      before { sign_in admin }

      it_behaves_like 'returns 404 Not Found'
    end

    context 'with XHR request as admin' do
      subject(:request) { get newsletter_path(newsletter), xhr: true }

      before { sign_in admin }

      it_behaves_like 'returns JSON response'
    end
  end

  describe 'GET #subscribers' do
    subject(:request) { get subscribers_newsletters_path }

    it_behaves_like 'accessible to admin users'
    it_behaves_like 'not accessible to non-admin users'
  end

  describe 'POST #subscribe' do
    subject(:request) { post subscribe_newsletters_path(email: email) }

    context 'with valid email' do
      let(:email) { 'test@email.com' }

      it_behaves_like 'accessible to authenticated users'
      it_behaves_like 'accessible to unauthenticated users'
    end

    context 'with invalid email' do
      let(:email) { 'invalid email' }

      it_behaves_like 'returns 422 Unprocessable Entity'
    end
  end

  describe 'GET #unsubscribe' do
    subject(:request) { get unsubscribe_newsletters_path }

    it_behaves_like 'accessible to authenticated users'
    it_behaves_like 'accessible to unauthenticated users'
  end

  describe 'POST #post_unsubscribe' do
    subject(:request) { post unsubscribe_newsletters_path, params: params }

    let(:newsletter_user) { create(:user, :newsletter) }

    context 'with valid input' do
      let(:params) do
        {
          newsletter_unsubscription: {
            email: newsletter_user.email,
            reasons: ['no_longer']
          }
        }
      end

      it_behaves_like 'accessible to authenticated users'
      it_behaves_like 'accessible to unauthenticated users'
    end

    context 'with invalid input' do
      let(:params) do
        {
          newsletter_unsubscription: {
            email: newsletter_user.email,
            reasons: ['invalid']
          }
        }
      end

      it_behaves_like 'returns 422 Unprocessable Entity'
    end

    context 'with not subscribed email' do
      let(:params) do
        {
          newsletter_unsubscription: {
            email: 'randon@email.com',
            reasons: ['no_longer']
          }
        }
      end

      it_behaves_like 'returns 200 OK'
    end
  end
end
