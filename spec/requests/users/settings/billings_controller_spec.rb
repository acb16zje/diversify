# frozen_string_literal: true

require 'rails_helper'

describe Users::Settings::BillingsController, type: :request do
  let(:user) { create(:user) }

  describe 'GET #show' do
    subject(:request) { get settings_billing_path }

    it_behaves_like 'accessible to authenticated users'
    it_behaves_like 'not accessible to unauthenticated users'
  end

  describe 'PUT #update' do
    subject(:request) { put settings_billing_path(plan: plan) }

    before do
      sign_in user
      request
      follow_redirect!
    end

    context 'with valid plan' do
      let(:plan) { 'ultimate' }

      it { expect(response.body).to include('Billing plan updated') }
    end

    context 'with invalid plan' do
      let(:plan) { 'invalid' }

      it { expect(response.body).to include('Invalid argument') }
    end
  end
end
