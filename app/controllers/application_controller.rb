# frozen_string_literal: true

# Default application controller
class ApplicationController < ActionController::Base
  # Ahoy gem, used in PagesController only
  skip_before_action :track_ahoy_visit

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protect_from_forgery with: :exception

  include Pagy::Backend

  def configure_permitted_parameters
    update_attrs = %i[password password_confirmation current_password]
    devise_parameter_sanitizer.permit :account_update, keys: update_attrs
  end

  rescue_from ActionController::ParameterMissing do
    head :bad_request
  end

  # RecordNotFound exception is raised when using *find* method
  rescue_from ActiveRecord::RecordNotFound do
    render_404
  end

  rescue_from ActionPolicy::Unauthorized do |_ex|
    # Exception object contains the following information
    # ex.policy #=> policy class, e.g. UserPolicy
    # ex.rule #=> applied rule, e.g. :show?
    render_403
  end

  private

  def render_403
    respond_to do |format|
      format.html {
        render 'errors/error_403', layout: 'errors', status: :forbidden
      }
      format.any { head :forbidden }
    end
  end

  def render_404
    respond_to do |format|
      format.html { render 'errors/error_404', status: :not_found }
      # Prevent the Rails CSRF protector from thinking a missing .js file is a JavaScript file
      format.js { render json: '', status: :not_found }
      format.any { head :not_found }
    end
  end
end
