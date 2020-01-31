# frozen_string_literal: true

# Error controller
class ErrorsController < ApplicationController
  skip_before_action :authenticate_user!

  layout 'errors'

  def error_403
    render status: 403
  end

  def error_404
    render status: 404
  end

  def error_422
    render status: 422
  end

  def error_500
    render status: 500
  end
end
