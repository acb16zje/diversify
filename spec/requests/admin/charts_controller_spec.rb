# frozen_string_literal: true

require 'rails_helper'

describe Admin::ChartsController, type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }

  describe 'authorisations' do
    before { sign_in admin }

    described_class.instance_methods(false).each do |route|
      describe "##{route}" do
        it {
          expect { get "/charts/#{route}" }
            .to be_authorized_to(:manage?, admin).with(AdminPolicy)
        }
      end
    end
  end

  described_class.instance_methods(false).each do |route|
    next if route == :unsubscription_by_newsletter

    describe "##{route}" do
      subject(:request) { get "/charts/#{route}", params: params }

      context 'with no date selected' do
        let(:params) { { chart: { date: '' } } }

        it_behaves_like 'accessible to admin users'
        it_behaves_like 'not accessible to non-admin users'
      end

      context 'with range of dates selected' do
        let(:params) do
          { chart: { date: "#{Date.yesterday}, #{Date.tomorrow}" } }
        end

        it_behaves_like 'accessible to admin users'
        it_behaves_like 'not accessible to non-admin users'
      end

      context 'with invalid single date selected' do
        let(:params) { { chart: { date: 'invalid date' } } }

        before { sign_in admin }

        it { expect { request }.to raise_error(ActionController::BadRequest) }
      end
    end
  end

  # Special format
  describe '#unsubscription_by_newsletter' do
    subject(:request) do
      get '/charts/unsubscription_by_newsletter', params: params
    end

    let(:newsletter) { create(:newsletter) }

    before do
      newsletter
      create(:newsletter_feedback, :no_longer, created_at: Time.zone.tomorrow)
    end

    context 'with no date selected' do
      let(:params) { { chart: { date: '' } } }

      it_behaves_like 'accessible to admin users'
      it_behaves_like 'not accessible to non-admin users'

      it 'returns all newsletter before feedback' do
        sign_in admin
        request
        expect(response.body).to eq("[[\"#{newsletter.title}, #{newsletter.created_at.utc.strftime('%d-%m-%Y')}\",1]]")
      end
    end

    context 'with range of dates selected' do
      let(:params) do
        { chart: { date: "#{Time.zone.yesterday}, #{Time.zone.yesterday}" } }
      end

      it_behaves_like 'accessible to admin users'
      it_behaves_like 'not accessible to non-admin users'
    end

    context 'with single date selected' do
      let(:params) { { chart: { date: Time.zone.today.to_s } } }

      before { sign_in admin }

      it { expect { request }.to raise_error(ActionController::BadRequest) }
    end
  end
end
