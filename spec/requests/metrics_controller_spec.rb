# frozen_string_literal: true

require 'rails_helper'

describe MetricsController, type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }

  describe 'authorisations' do
    before { sign_in admin }

    it {
      expect { get metrics_path }
        .to be_authorized_to(:manage?, admin).with(MetricPolicy)
    }
    it {
      expect { get traffic_metrics_path }
        .to be_authorized_to(:manage?, admin).with(MetricPolicy)
    }
  end

  describe '#index' do
    context 'when not signed in' do
      it {
        get metrics_path
        expect(response).to redirect_to(new_user_session_path)
      }
    end

    context 'when signed in as user' do
      before { sign_in user }

      it {
        get metrics_path
        expect(response).to have_http_status(:forbidden)
      }
    end

    context 'when signed in as admin' do
      before { sign_in admin }

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

    context 'when signed in as user' do
      before { sign_in user }

      it {
        get traffic_metrics_path
        expect(response).to have_http_status(:forbidden)
      }
    end

    context 'when signed in as admin' do
      before { sign_in admin }

      it {
        get traffic_metrics_path
        expect(response).to have_http_status(:ok)
      }
    end
  end
end
