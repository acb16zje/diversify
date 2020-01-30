# frozen_string_literal: true

require 'rails_helper'

CHART_ROUTES = %w[
  subscription_ratio
  subscription_by_date
  landing_page_feedback
  social_share_ratio
  social_share_by_date
  referrers_ratio
  referrers_by_date
  average_time_spent_per_page
  number_of_visits_per_page
  newsletter_subscription_by_date
  unsubscription_by_newsletter
  unsubscription_reason
].freeze

describe ChartsController, type: :request do
  let(:user) { create(:user) }

  CHART_ROUTES.each do |route|
    describe "##{route}" do
      context 'when not signed in' do
        it {
          get "/charts/#{route}"
          expect(response).to redirect_to(new_user_session_path)
        }
      end

      context 'when signed in' do
        before { sign_in user }

        it {
          get "/charts/#{route}", params: { chart: { date: [] } }
          expect(response.content_type).to include('application/json')
        }
      end
    end
  end

  # Special format
  describe '#unsubscription_by_newsletter' do
    context 'when signed in' do
      let(:newsletter) { create(:newsletter) }
      let(:feedback_after_newsletter) do
        create(:newsletter_feedback, :no_longer, created_at: Time.zone.tomorrow)
      end

      before do
        newsletter
        feedback_after_newsletter
        sign_in user
      end

      it {
        get '/charts/unsubscription_by_newsletter', params: { chart: { date: [] } }
        expect(response.body)
          .to eq("[[\"#{newsletter.title}, #{newsletter.created_at.utc.strftime('%d-%m-%Y')}\",1]]")
      }
    end
  end
end
