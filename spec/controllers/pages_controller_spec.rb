# frozen_string_literal: true

require 'rails_helper'

describe PagesController do
  describe '#track_time' do
    context 'with valid params' do
      it 'receive 200 OK' do
        post :track_time, xhr: true, params: {
          time: 123,
          pathname: love_pages_path
        }
        expect(response.status).to eq(200)
      end
    end

    context 'with invalid params' do
      it 'receive 400 Bad Request' do
        post :track_time, xhr: true
        expect(response.status).to eq(400)
      end
    end
  end

  describe '#submit_feedback' do
    context 'with invalid params' do
      it 'receive 400 Bad Request' do
        post :submit_feedback, xhr: true
        expect(response.status).to eq(400)
      end
    end
  end
end
