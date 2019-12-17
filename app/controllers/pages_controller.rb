# frozen_string_literal: true

# Controller for landing pages
class PagesController < ApplicationController
  layout 'landing_page'
  skip_authorization_check

  # Function to track subscriptions
  # should be changed once proper subscription system has been completed
  def newsletter
    @newsletter_subscription = NewsletterSubscription.new
    ahoy.track 'Clicked pricing link', type: params[:type] if valid_sub_type?(params[:type])
  end

  def track_social
    
    ahoy.track 'Click Social', type: params[:value] if valid_social_type?(params[:value])
    head :ok
  end


  # Function to track time spent in a page
  def track_time
    head :bad_request unless valid_request?(params)

    pathname = params[:pathname]
    time = params[:time]

    return unless valid_pathname?(pathname)

    ahoy.track 'Time Spent',
               time_spent: millisec_to_sec(time),
               pathname: pathname
    head :ok
  end

  def submit_feedback
    feedback = LandingFeedback.new(
      smiley: params[:smiley],
      channel: params[:channel],
      interest: ActiveModel::Type::Boolean.new.cast(params[:interest])
    )

    if feedback_params && feedback.save
      render json: { message: 'Feedback Submitted',
                     class: flash_class('success')
                    }
    else
      render json: { message: 'Submission Failed',
                     class: flash_class('error')
                   }, status: 400
    end
  end

  private

  def millisec_to_sec(time)
    time.to_f.round / 1000
  end

  def valid_request?(params)
    params.key?(:time) && params.key?(:pathname)
  end

  def valid_pathname?(pathname)
    pathname.present? &&
      !pathname.include?('metrics') &&
      !pathname.include?('newsletters')
  end

  def valid_sub_type?(params)
    %w(Free Pro Enterprise).include? params
  end

  def valid_social_type?(params)
    %w(Facebook Twitter).include? params
  end

  def feedback_params
    !params[:smiley].blank? && !params[:channel].blank? && !params[:interest].blank?
  end
end