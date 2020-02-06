# frozen_string_literal: true

# Controller for profile and settings
class UsersController < ApplicationController
  include DeviseHelper
  include AvatarHelper

  skip_before_action :authenticate_user!, only: :show

  before_action :set_user, only: %i[show edit update]

  layout 'devise'

  def show; end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:toast] = { type: 'success', message: ['Profile Updated'] }
      redirect_to edit_user_path(@user.id)
    else
      render :edit
    end
  end

  def settings; end

  def disconnect_omniauth
    if valid_disconnect?
      res = Identity.destroy_by(user: current_user, provider: params[:provider])

      flash[:toast] = if res == []
                        { type: 'error', message: ['Invalid Request'] }
                      else
                        { type: 'success', message: ['Account Disconnected'] }
                      end
    else
      flash[:toast] = {
        type: 'error',
        message: ['Please set up a password before disabling all Social Accounts']
      }
    end

    redirect_to settings_users_path
  end

  private

  def user_params
    params.require(:user).permit(:name,:avatar)
  end

  def set_user
    @user = User.find(params[:id])
    authorize! @user
  end

  def valid_disconnect?
    !current_user.password_automatically_set? ||
      current_user.identities.size > 1
  end
end
