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
    if valid_disconnect?
      response = Identity.destroy_by(user: current_user,
                                     provider: params[:provider])
      response == [] ? destroy_fail : destroy_success
    else
      flash[:toast] = { type: 'error', message:
        ['Please set up a password before disabling all Social Accounts'] }
      redirect_to settings_users_path, status: :bad_request
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
    authorize! @user
  end

  def valid_disconnect?
    Identity.where(user: current_user).count > 1 ||
      current_user.encrypted_password?
  end

  def destroy_fail
    flash[:toast] = { type: 'error', message: ['Invalid Request'] }
    redirect_to settings_users_path, status: :bad_request
  end

  def destroy_success
    flash[:toast] = { type: 'success', message: ['Account Disconnected'] }
    redirect_to settings_users_path, status: :ok
  end

end
