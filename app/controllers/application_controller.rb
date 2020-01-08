# frozen_string_literal: true

# Default application controller
class ApplicationController < ActionController::Base
  # Ensure that CanCanCan is correctly configured
  # and authorising actions on each controller
  # check_authorization

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_action :track_action

  rescue_from ActionController::ParameterMissing do
    render json: { message: 'Bad Request' }, status: :bad_request
  end

  # Catch NotFound exceptions and handle them neatly, when URLs are mistyped or mislinked
  rescue_from ActiveRecord::RecordNotFound do
    render template: 'errors/error_404', status: :not_found
  end

  rescue_from CanCan::AccessDenied do
    render template: 'errors/error_403', status: :forbidden
  end

  protected

  # Ahoy Gem function to track actions
  def track_action
    return if request.xhr? || request.path_parameters[:controller] == 'metrics'

    ahoy.track 'Ran action', request.path_parameters
  end

  # Returns the class for notification
  def flash_class(type)
    case type
    when 'success'
      'is-success'
    when 'error'
      'is-danger'
    else
      'is-primary'
    end
  end
end
