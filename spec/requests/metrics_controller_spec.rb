# frozen_string_literal: true

require 'rails_helper'

describe MetricsController, type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }

  describe 'authorisations' do
    before { sign_in admin }

    describe '#index' do
      it {
        expect { get metrics_path }
          .to be_authorized_to(:manage?, admin).with(MetricPolicy)
      }
    end

    describe '#traffic' do
      it {
        expect { get traffic_metrics_path }
          .to be_authorized_to(:manage?, admin).with(MetricPolicy)
      }
    end
  end

  describe '#index' do
    subject(:request) { get metrics_path }

    it_behaves_like 'accessible to admin users'
    it_behaves_like 'not accessible to non-admin users'
  end

  describe '#traffic' do
    subject(:request) { get traffic_metrics_path }

    it_behaves_like 'accessible to admin users'
    it_behaves_like 'not accessible to non-admin users'
  end
end
