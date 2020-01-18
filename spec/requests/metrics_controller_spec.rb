# frozen_string_literal: true

require 'rails_helper'

describe MetricsController, type: :request do
  let(:user) { create(:user) }

  describe '#index' do
    context 'when not signed in' do
      it {
        get metrics_path
        expect(response).to redirect_to(new_user_session_path)
      }
    end

    context 'when signed in' do
      before { sign_in user }

      it {
        get metrics_path
        expect(response).to have_http_status(:ok)
      }
    end
  end

  describe '#traffic' do
    context 'when not signed in' do
      it {
        get traffic_metrics_path
        expect(response).to redirect_to(new_user_session_path)
      }
    end

    context 'when signed in' do
      before { sign_in user }

      it {
        get traffic_metrics_path
        expect(response).to have_http_status(:ok)
      }
    end
  end
end
