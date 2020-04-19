# frozen_string_literal: true

class Admin::BaseController < ApplicationController
  before_action :admin_authorize

  layout 'admin'

  private

  def admin_authorize
    authorize! current_user, with: AdminPolicy
  end
end
