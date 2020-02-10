# frozen_string_literal: true

class Users::Settings::AccountsController < Users::Settings::BaseController
  def show
    render 'users/settings/account'
  end

  def disconnect_omniauth
    if disconnect_provider_allowed?
      res = current_user.identities.destroy_by(provider: params[:provider])

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

    redirect_to settings_account_path
  end

  private

  def disconnect_provider_allowed?
    !current_user.password_automatically_set? ||
      current_user.identities.size > 1
  end
end
