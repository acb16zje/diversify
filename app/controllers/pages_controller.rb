# frozen_string_literal: true

# Controller for landing pages
class PagesController < ApplicationController
  layout 'landing_page'
  skip_authorization_check

  # Function to track subscriptions
  # should be changed once proper subscription system has been completed
  def newsletter
    @newsletter_subscription = NewsletterSubscription.new
    ahoy.track 'Clicked pricing link', type: params[:type] if params.key?(:type)
  end

  # Function to track time spent in a page
  def track_time
    if params.key?(:time)
      time = params[:time]
      ahoy.track 'Time Spent', time_spent: millisec_to_sec(time), location: params[:location]
    else
      head 500
    end
  end

  def submit_feedback
    feedback = LandingFeedback.new(
      smiley: params[:smiley], channel: params[:channel],
      interest: ActiveModel::Type::Boolean.new.cast(params[:interest])
    )
    respond_to do |format|
      format.json do
        render json: (
        if feedback_params && feedback.save
          { message: 'Feedback Submitted', class: flash_class('success') }
        else
          { message: 'Submission Failed', class: flash_class('error') }
        end), status: 200
      end
    end
  end

  private

  def millisec_to_sec(time)
    time.to_f.round / 1000
  end

  def feedback_params
    params.key?(:smiley) && params.key?(:channel) && params.key?(:interest)
  end
end
