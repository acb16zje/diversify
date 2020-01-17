# frozen_string_literal: true

require 'rails_helper'

describe PagesController, type: :request do
  describe '#track_social' do
    context 'with valid social type' do
      it {
        post track_social_pages_path, params: { type: 'Facebook' }, xhr: true
        expect(response).to have_http_status(:ok)
      }

      it {
        post track_social_pages_path, params: { type: 'Twitter' }, xhr: true
        expect(response).to have_http_status(:ok)
      }

      it {
        post track_social_pages_path, params: { type: 'Email' }, xhr: true
        expect(response).to have_http_status(:ok)
      }
    end

    context 'with invalid social type' do
      it {
        post track_social_pages_path, params: { type: 'foobar' }, xhr: true
        expect(response).to have_http_status(:bad_request)
      }
    end
  end

  describe '#track_time' do
    context 'with valid params' do
      it {
        post track_time_pages_path, params: { time: 1, pathname: about_pages_path },
                                    xhr: true
        expect(response).to have_http_status(:ok)
      }

      it {
        post track_time_pages_path, params: { time: 1, pathname: love_pages_path },
                                    xhr: true
        expect(response).to have_http_status(:ok)
      }
    end

    context 'with invalid params' do
      it {
        post track_time_pages_path, xhr: true
        expect(response).to have_http_status(:bad_request)
      }

      it {
        post track_time_pages_path, params: { time: 1 }, xhr: true
        expect(response).to have_http_status(:bad_request)
      }

      it {
        post track_time_pages_path, params: { pathname: metrics_path }, xhr: true
        expect(response).to have_http_status(:bad_request)
      }
    end
  end

  describe '#submit_feedback' do
    context 'with valid params' do
      it {
        post submit_feedback_pages_path,
             params: { landing_feedback: { smiley: 'happy', channel: 'Newspaper', interest: true } },
             xhr: true
        expect(response).to have_http_status(:ok)
      }
    end

    context 'with invalid params' do
      it {
        post submit_feedback_pages_path,
             params: { smiley: 'happy', interest: true },
             xhr: true
        expect(response).to have_http_status(:bad_request)
      }

      it {
        post submit_feedback_pages_path,
             params: { landing_feedback: { smiley: 'happy', channel: 'foo', interest: true } },
             xhr: true
        expect(response).to have_http_status(:unprocessable_entity)
      }
    end
  end
end
