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

  ## The following are used by our Responder service classes so we can access
  ## the instance variable for the current resource easily via a standard method
  def resource_name
    controller_name.demodulize.singularize
  end

  def current_resource
    instance_variable_get(:"@#{resource_name}")
  end

  def current_resource=(val)
    instance_variable_set(:"@#{resource_name}", val)
  end

  # Catch NotFound exceptions and handle them neatly, when URLs are mistyped or mislinked
  rescue_from ActiveRecord::RecordNotFound do
    render template: 'errors/error_404', status: 404
  end
  rescue_from CanCan::AccessDenied do
    render template: 'errors/error_403', status: 403
  end

  # IE over HTTPS will not download if browser caching is off, so allow browser caching when sending files
  def send_file(file, opts = {})
    response.headers['Cache-Control'] = 'private, proxy-revalidate' # Still prevent proxy caching
    response.headers['Pragma'] = 'cache'
    response.headers['Expires'] = '0'
    super(file, opts)
  end

  protected

  # Ahoy Gem function to track actions
  def track_action
    return if request.xhr? || request.path_parameters[:controller] == 'metrics'

    ahoy.track 'Ran action', request.path_parameters
  end

  def flash_class(level)
    case level
    when 'notice'
      'is-primary'
    when 'success'
      'is-success'
    when 'error'
      'is-danger'
    when 'alert'
      'is-warning'
    end
  end

  private

  def update_headers_to_disable_caching
    response.headers['Cache-Control'] = 'no-cache, no-cache="set-cookie", no-store, private, proxy-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '-1'
  end
end
