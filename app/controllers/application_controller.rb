# frozen_string_literal: true

# Default application controller
class ApplicationController < ActionController::Base
  layout :layout_by_resource

  # Ahoy gem, used in PagesController only
  skip_before_action :track_ahoy_visit

  protect_from_forgery with: :exception

  rescue_from ActionController::ParameterMissing do
    render json: { message: 'Bad Request' }, status: :bad_request
  end

  # Catch NotFound exceptions and handle them neatly, when URLs are mistyped or mislinked
  rescue_from ActiveRecord::RecordNotFound do
    render template: 'errors/error_404', status: :not_found
  end

  # protected

  # def after_sign_in_path_for(_resource)
  #   root_path
  # end

  private

  def layout_by_resource
    devise_controller? ? 'devise' : 'application'
  end
end
