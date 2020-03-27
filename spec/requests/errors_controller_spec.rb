# frozen_string_literal: true

require 'rails_helper'

describe ErrorsController, type: :request do
  describe '#error_403' do
    before { get '/403' }

    it { expect(response).to have_http_status(:forbidden) }
  end

  describe '#error_404' do
    before { get '/404' }

    it { expect(response).to have_http_status(:not_found) }
  end

  describe '#error_422' do
    before { get '/422' }

    it { expect(response).to have_http_status(:unprocessable_entity) }
  end

  describe '#error_500' do
    before { get '/500' }

    it { expect(response).to have_http_status(:internal_server_error) }
  end
end
