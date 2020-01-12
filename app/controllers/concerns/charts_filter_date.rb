# frozen_string_literal: true

module ChartsFilterDate
  extend ActiveSupport::Concern

  def filter_date_by_time_column
    filter_date('time')
  end

  def filter_date_by_created_at_column
    filter_date('created_at')
  end

  def filter_date_by_started_at_column
    filter_date('started_at')
  end

  private

  def date_params_present?
    chart_params[:date].present?
  end

  def filter_date(column)
    return unless date_params_present?

    date_params = chart_params[:date].split(',')
    start_date = Time.zone.parse(date_params[0]).beginning_of_day
    end_date = Time.zone.parse(date_params[1]).end_of_day

    case action_name
    when 'landing_page_feedback', 'newsletter_subscription_by_date'
      # Class of ActiveRecord::Relation
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
