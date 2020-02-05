# frozen_string_literal: true

require 'rails_helper'

describe ErrorsController, type: :request do
  describe '#error_403' do
    it {
      get '/403'
      expect(response).to have_http_status(:forbidden)
    }
  end

  describe '#error_404' do
    it {
      get '/404'
      expect(response).to have_http_status(:not_found)
    }
  end

  describe '#error_422' do
    it {
      get '/422'
      expect(response).to have_http_status(:unprocessable_entity)
    }
  end

  describe '#error_500' do
    it {
      get '/500'
      expect(response).to have_http_status(:internal_server_error)
    }
  end
end
