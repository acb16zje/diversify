# frozen_string_literal: true

# Error controller
class ErrorsController < ApplicationController
  skip_before_action :authenticate_user!

  layout 'errors'
end
