# frozen_string_literal: true

# Error controller
class ErrorsController < ApplicationController
  layout 'landing_page'

  def error_403; end

  def error_404; end

  def error_422; end

  def error_500; end
end
