# frozen_string_literal: true

# Controller for profile and settings
class UsersController < ApplicationController
  include DeviseHelper

  skip_before_action :authenticate_user!, only: :show

  before_action :set_user, only: %i[show edit update]

  layout 'devise'

  def show; end

  def edit; end

  def update; end

  def settings; end

  def disconnect_omniauth
    if current_user.encrypted_password?
      Identity.destroy_by(user: current_user, provider: params[:provider])
      flash[:toast] = { type: 'success', message: ['Account Disconnected'] }
    else
      flash[:toast] = {
        type: 'error',
        message: ['Please set up a password before disconnecting all social accounts']
      }
    end

    redirect_to settings_users_path
  end

  private

  def set_user
    @user = User.find(params[:id])
    authorize! @user
  end
end
