# frozen_string_literal: true

class Users::Settings::AccountsController < Users::Settings::BaseController
  def show
    render 'users/settings/account'
  end

  def disconnect_omniauth
    identity = current_user.identities.find_by!(provider: params[:provider])

    if disconnect_provider_allowed?
      identity.destroy
      flash[:toast_success] = 'Account Disconnected'
    else
      flash[:toast_error] = 'Please set up a password before disabling all Social Accounts'
    end

    redirect_to settings_account_path
  end

  private

  def disconnect_provider_allowed?
    !current_user.password_automatically_set? ||
      current_user.identities.size > 1
  end
end
