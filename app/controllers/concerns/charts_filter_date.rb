# frozen_string_literal: true

module ChartsFilterDate
  extend ActiveSupport::Concern

  def filter_date_by_time_column
    filter_date('time')
  end

  def filter_date_by_created_at
    filter_date('created_at')
  end

  def filter_date_by_updated_at
    filter_date('updated_at')
  end

  def filter_date_by_started_at
    filter_date('started_at')
  end

  private

  def date_params
    chart_params[:date].split(',')
  end

  def start_date
    Time.zone.parse(date_params[0]).beginning_of_day
  rescue StandardError
    raise ActionController::BadRequest
  end

  def end_date
    Time.zone.parse(date_params[1]).end_of_day
  rescue StandardError
    raise ActionController::BadRequest
  end

  def filter_date(column)
    return if chart_params[:date].blank?

    case action_name
    when 'landing_page_feedback', 'newsletter_subscription_by_date'
      # Array of ActiveRecord::Relation objects
      @records.map! do |record|
        record.where(column + ' BETWEEN ? AND ?', start_date, end_date)
      end
    when 'unsubscription_by_newsletter'
      # Class of Newsletter, cannot use where
      @records.filter! do |record|
        record[:created_at].between?(start_date, end_date)
      end
    else
      @records = @records.where(column + ' BETWEEN ? AND ?', start_date, end_date)
    end
  end
end
