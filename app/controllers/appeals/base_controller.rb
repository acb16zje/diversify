# frozen_string_literal: true

class Appeals::BaseController < ApplicationController
  rescue_from ActionPolicy::Unauthorized do
    head :forbidden
  end
end
