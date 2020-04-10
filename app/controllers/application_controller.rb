# frozen_string_literal: true

# Default application controller
class ApplicationController < ActionController::Base
  include Pagy::Backend

  # Ahoy gem, used in PagesController only
  skip_before_action :track_ahoy_visit

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protect_from_forgery with: :exception, prepend: true

  rescue_from ActionController::ParameterMissing do
    head :bad_request
  end

  # 1. RecordNotFound exception is raised when using *find* method
  # 2. Exception object contains the following information
  #    ex.policy #=> policy class, e.g. UserPolicy
  #    ex.rule #=> applied rule, e.g. :show?
  # 3. Pagy VariableError or OverflowError
  rescue_from ActiveRecord::RecordNotFound,
              ActionPolicy::Unauthorized,
              Pagy::VariableError do
    render_404
  end

  rescue_from ActiveRecord::StatementInvalid do
    render json: { message: 'Invalid Statement' }, status: :unprocessable_entity
  end

  def view_to_html_string(partial, locals = {})
    render_to_string(partial, locals: locals, layout: false, formats: [:html])
  end

  private

  def configure_permitted_parameters
    update_attrs = %i[password password_confirmation current_password]
    devise_parameter_sanitizer.permit :account_update, keys: update_attrs
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
