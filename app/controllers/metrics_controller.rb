# frozen_string_literal: true

# Controller for metrics
class MetricsController < ApplicationController
  before_action :metric_authorize
  layout 'metrics_page'

  def index
    @data = {
      subscribed_count: NewsletterSubscription.subscribed_count,
      today_count: Ahoy::Visit.today_count,
      total_count: Ahoy::Visit.count
    }.freeze
  end

  def traffic
    @data = {
      device_type: Ahoy::Visit.group(:device_type).size.chart_json,
      browser: Ahoy::Visit.group(:browser).size.chart_json,
      country: Ahoy::Visit.group(:country).size.chart_json
    }.freeze
  end

  private

  def metric_authorize
    authorize! current_user, with: MetricPolicy
  end
end
