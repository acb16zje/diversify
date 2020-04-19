# frozen_string_literal: true

class Admin::ChartsController < Admin::BaseController
  include Admin::Concerns::ChartsFilterDate

  before_action :load_plan_subscriptions,
                only: %i[subscription_ratio subscription_by_date]

  before_action :load_landing_page_feedback, only: :landing_page_feedback

  before_action :load_ahoy_event_social,
                only: %i[social_share_ratio social_share_by_date]

  before_action :load_ahoy_visit_referrer,
                only: %i[referrers_ratio referrers_by_date]

  before_action :load_ahoy_event_time_spent, only: :average_time_spent_per_page

  before_action :load_ahoy_visit_per_page, only: :number_of_visits_per_page

  before_action :load_newsletter_subscription_by_date,
                only: :newsletter_subscription_by_date

  before_action :load_unsubscription_by_newsletter,
                only: :unsubscription_by_newsletter

  before_action :load_unsubscription_reason, only: :unsubscription_reason

  # These charts are filtered by 'time' column
  before_action :filter_date_by_time_column,
                only: %i[
                  social_share_ratio
                  social_share_by_date
                  average_time_spent_per_page
                  number_of_visits_per_page
                ]

  # These charts are filtered by 'created_at' column
  before_action :filter_date_by_created_at,
                only: %i[
                  landing_page_feedback
                  newsletter_subscription_by_date
                  unsubscription_by_newsletter
                  unsubscription_reason
                ]

  before_action :filter_date_by_updated_at,
                only: %i[subscription_ratio subscription_by_date]

  # These charts are filtered by 'started_at' column
  before_action :filter_date_by_started_at,
                only: %i[referrers_ratio referrers_by_date]

  def subscription_ratio
    render json: @records.size
  end

  def subscription_by_date
    render json: @records.group_by_day(:updated_at).size.chart_json
  end

  def landing_page_feedback
    render json: { data: [
      @records[0].group(:smiley).size,
      @records[1].group(:channel).size,
      @records[2].group(:interest).size
    ] }
  end

  def social_share_ratio
    render json: @records.type_size
  end

  def social_share_by_date
    render json: @records.type_time_size.chart_json
  end

  def referrers_ratio
    render json: @records.size
  end

  def referrers_by_date
    render json: @records.group_by_day(:started_at).size.chart_json
  end

  def average_time_spent_per_page
    render json: @records
      .group("properties ->> 'pathname'")
      .average("cast(properties ->> 'time_spent' as integer)")
  end

  def number_of_visits_per_page
    render json: @records.group("properties ->> 'action'").size
  end

  def newsletter_subscription_by_date
    render json: [
      { name: 'Subscription', data: @records[0].group_by_day(:created_at).size },
      { name: 'Unsubscription', data: @records[1].group_by_day(:created_at).size }
    ]
  end

  def unsubscription_by_newsletter
    @records.map! do |record|
      ["#{record['title']}, #{record['created_at'].utc.strftime('%d-%m-%Y')}",
       record['feedback_count']]
    end

    render json: @records
  end

  def unsubscription_reason
    render json: NewsletterFeedback.count_reason(@records)
  end

  private

  def chart_params
    params.require(:chart).permit(:date)
  end

  def load_plan_subscriptions
    @records = License.group(:plan)
  end

  def load_ahoy_event_social
    @records = Ahoy::Event.social
  end

  def load_landing_page_feedback
    @records = [
      LandingFeedback.select(:smiley, :created_at),
      LandingFeedback.select(:channel, :created_at),
      LandingFeedback.select(:interest, :created_at)
    ]
  end

  def load_ahoy_visit_referrer
    @records = Ahoy::Visit.group(:referrer)
  end

  def load_ahoy_event_time_spent
    @records = Ahoy::Event.where(name: 'Time Spent')
  end

  def load_ahoy_visit_per_page
    @records = Ahoy::Event.action
  end

  def load_newsletter_subscription_by_date
    @records = [
      NewsletterSubscription.select(:created_at),
      NewsletterFeedback.select(:created_at)
    ]
  end

  def load_unsubscription_by_newsletter
    @records = Newsletter.unsubscription_by_newsletter
  end

  def load_unsubscription_reason
    @records = NewsletterFeedback.select(:reasons)
  end
end
