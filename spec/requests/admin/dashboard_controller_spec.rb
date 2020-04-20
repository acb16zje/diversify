# frozen_string_literal: true

require 'rails_helper'

describe Admin::DashboardController, type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }

  describe 'GET #index' do
    subject(:request) { get admin_dashboard_index_path }

    it_behaves_like 'accessible to admin users'
    it_behaves_like 'not accessible to non-admin users'
  end
end
