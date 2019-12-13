# frozen_string_literal: true

# Controller for landing pages
class PagesController < ApplicationController
  layout 'landing_page'
  skip_authorization_check

  def home
    @current_nav_identifier = :home
  end

  # Function to track subscriptions
  # should be changed once proper subscription system has been completed
  def newsletter
    @newsletter_subscription = NewsletterSubscription.new
    ahoy.track 'Clicked pricing link', type: params[:type] if params.key?(:type)
  end

  def newsletter_subscriptions
    if params.key?(:email)
      newsletter_subscription = NewsletterSubscription.new(
        date_subscribed: Time.now, email: params[:email]
      )
      if newsletter_subscription.save
        NewsletterMailer.send_welcome(params[:email]).deliver_now
        message = 'Newsletter Subscribed!'
        class_card = flash_class('success')
      else
        message = 'Subscription Failed'
        class_card = flash_class('error')
      end
    else
      message = 'No Email'
      class_card = flash_class('error')
    end
    respond_to do |format|
      format.json do
        render json: { message: message, class: class_card },
               status: 200
      end
    end
  end

  def feedback_submission
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

  # Function to track time spent in a page
  def track_time
    if params.key?(:time)
      time = params[:time]
      ahoy.track 'Time Spent', time_spent: millisec_to_sec(time), location: params[:location]
    else
      head 500
    end
  end

  private

  def millisec_to_sec(time)
    time.to_f.round / 1000
  end

  #def valid_location?(location)
  #  !(location.include? 'metrics') && !(location.include? 'newsletters')
  #end

  def feedback_params
    params.key?(:smiley) && params.key?(:channel) && params.key?(:interest)
  end
end
