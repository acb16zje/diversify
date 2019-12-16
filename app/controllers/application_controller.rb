# frozen_string_literal: true

# Default application controller
class ApplicationController < ActionController::Base
  # Ensure that CanCanCan is correctly configured
  # and authorising actions on each controller
  # check_authorization

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :update_headers_to_disable_caching

  after_action :track_action

  # Catch NotFound exceptions and handle them neatly, when URLs are mistyped or mislinked
  rescue_from ActiveRecord::RecordNotFound do
    render template: 'errors/error_404', status: 404
  end

  rescue_from CanCan::AccessDenied do
    render template: 'errors/error_403', status: 403
  end

  protected

  # Ahoy Gem function to track actions
  def track_action
    return if request.xhr? || request.path_parameters[:controller] == 'metrics'

    ahoy.track 'Ran action', request.path_parameters
  end

  def flash_class(level)
    case level
    when 'success'
      'is-success'
    when 'error'
      'is-danger'
    else
      'is-primary'
    end
  end

  private

  def update_headers_to_disable_caching
    response.headers['Cache-Control'] = 'no-cache, no-cache="set-cookie", no-store, private, proxy-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '-1'
  end
end
