# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  helper UserHelper
  respond_to :js
  layout 'devise'

  def show
    authorize! @user
  end

  def edit
    authorize! @user
  end

  def settings; end

  def unsubscribe_omniauth
    return unless request.xhr?

    if Identity.where(user: current_user).count <= 1 && current_user.encrypted_password.blank?
      render json: { message: 'Please set up a password before disabling all Social Accounts' }, status: :bad_request
    else
      Identity.destroy_by(user: current_user, provider: params[:provider])
      render js: "window.location='#{settings_users_path}'"
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end
end
