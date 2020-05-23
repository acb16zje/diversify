# frozen_string_literal: true

# Controller for landing pages
class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  before_action :track_ahoy_visit

  after_action :track_action, except: :track_time, unless: -> { request.xhr? }

  layout 'landing_page'

  def track_social
    return head :bad_request unless valid_social_type?

    ahoy.track 'Click Social', type: params[:type]
    head :ok
  end

  # Function to track time spent in a page
  def track_time
    return head :bad_request unless valid_request?

    ahoy.track 'Time Spent',
               time_spent: params[:time].to_f.round / 1000,
               pathname: params[:pathname]
    head :ok
  end

  def submit_feedback
    if LandingFeedback.new(feedback_params).save
      render json: { message: 'Thank you for your feedback' }
    else
      render json: { message: 'Submission Failed' }, status: :unprocessable_entity
    end
  end

  private

  # Ahoy Gem function to track actions
  def track_action
    ahoy.track('Ran action', request.path_parameters)
  end

  def valid_request?
    params.require(%i[time pathname]) && valid_pathname?(params[:pathname])
  end

  def valid_pathname?(pathname)
    pathname.in?(%w[/ /pricing /about /love /features /feedback /newsletter])
  end

  def valid_social_type?
    params[:type].in?(%w[Facebook Twitter Email])
  end

  def feedback_params
    params.require(:landing_feedback).permit(%i[smiley channel interest])
  end
end
