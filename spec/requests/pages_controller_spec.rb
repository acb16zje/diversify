# frozen_string_literal: true

require 'rails_helper'

describe PagesController, type: :request do
  let(:user) { create(:user) }

  describe '#track_social' do
    subject(:request) { post track_social_pages_path(params), xhr: true }

    context 'with Facebook' do
      let(:params) { { type: 'Facebook' } }

      it_behaves_like 'accessible to authenticated users'
      it_behaves_like 'accessible to unauthenticated users'
    end

    context 'with Twitter' do
      let(:params) { { type: 'Twitter' } }

      it_behaves_like 'accessible to authenticated users'
      it_behaves_like 'accessible to unauthenticated users'
    end

    context 'with Email' do
      let(:params) { { type: 'Email' } }

      it_behaves_like 'accessible to authenticated users'
      it_behaves_like 'accessible to unauthenticated users'
    end

    context 'with invalid social type' do
      let(:params) { { type: 'foobar' } }

      it_behaves_like 'returns 400 Bad Request'
    end
  end

  describe '#track_time' do
    subject(:request) { post track_time_pages_path(params), xhr: true }

    context 'with valid params' do
      let(:params) { { time: 1, pathname: about_pages_path } }

      it_behaves_like 'accessible to authenticated users'
      it_behaves_like 'accessible to unauthenticated users'
    end

    context 'without params' do
      let(:params) { {} }

      it_behaves_like 'returns 400 Bad Request'
    end

    context 'without pathname' do
      let(:params) { { time: 1 } }

      it_behaves_like 'returns 400 Bad Request'
    end

    context 'without time' do
      let(:params) { { pathname: metrics_path } }

      it_behaves_like 'returns 400 Bad Request'
    end
  end

  describe '#submit_feedback' do
    subject(:request) { post submit_feedback_pages_path(params), xhr: true }

    context 'with valid params' do
      let(:params) { { landing_feedback: { smiley: 'happy', channel: 'Newspaper', interest: true } } }

      it_behaves_like 'accessible to authenticated users'
      it_behaves_like 'accessible to unauthenticated users'
    end

    context 'without an option' do
      let(:params) { { smiley: 'happy', interest: true } }

      it_behaves_like 'returns 400 Bad Request'
    end

    context 'with invalid option value' do
      let(:params) { { landing_feedback: { smiley: 'happy', channel: 'foo', interest: true } } }

      it_behaves_like 'returns 422 Unprocessable Entity'
    end
  end
end
