# frozen_string_literal: true

# Default application controller
class ApplicationController < ActionController::Base
  # Ahoy gem, used in PagesController only
  skip_before_action :track_ahoy_visit

  protect_from_forgery with: :exception

  rescue_from ActionController::ParameterMissing do
    render json: { message: 'Bad Request' }, status: :bad_request
  end

  # RecordNotFound exception is raised when using *find* method
  rescue_from ActiveRecord::RecordNotFound do
    render_404
  end

  # protected

  # def after_sign_in_path_for(_resource)
  #   root_path
  # end

  private

  def render_404
    respond_to do |format|
      format.html { render 'errors/error_404', status: :not_found }
      # Prevent the Rails CSRF protector from thinking a missing .js file is a JavaScript file
      format.js { render json: { message: 'Not Found' }, status: :not_found }
      format.any { head :not_found }
    end
  end
end
