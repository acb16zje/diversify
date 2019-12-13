# frozen_string_literal: true

# Error controller
class ErrorsController < ApplicationController
  skip_before_action :ie_warning
  skip_before_action :verify_authenticity_token, only: [:error_422]
  skip_authorization_check

  layout 'landing_page'

  def error_403; end

  def error_404; end

  def error_422; end

  def error_500
    render
  rescue StandardError
    render layout: 'landing_page'
  end
end
