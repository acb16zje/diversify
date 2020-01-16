# frozen_string_literal: true

# controller for OAuth Devise
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :prepare_auth, only: %i[google_oauth2 twitter facebook]

  def google_oauth2
    prepare_user
    if save_success?
      user_signed_in? ? connect_success_action : sign_in_success_action
    else
      fail_action
    end
  end

  def twitter
    prepare_user
    if save_success?
      user_signed_in? ? connect_success_action : sign_in_success_action
    else
      session['devise.twitter_data'] = @auth.except('extra')
      fail_action
    end
  end

  def facebook
    prepare_user
    if save_success?
      user_signed_in? ? connect_success_action : sign_in_success_action
    else
      session['devise.facebook_data'] = @auth.except('extra')
      fail_action
    end
  end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end

  private

  def prepare_auth
    @auth = request.env['omniauth.auth']
    @identity = Identity.where(provider: @auth['provider'],
                              uid: @auth['uid']).first_or_create

    if user_signed_in? && !@identity.new_record?
      flash[:toast] = { type: 'error', message: ['Account has been taken'] }
      redirect_to settings_users_path
    end
  end

  def prepare_user
    @user =
      if user_signed_in?
        current_user
      else
        User.where(id: @identity.user_id).first_or_create(
            email: @auth['info']['email'], name: @auth['info']['name']
        )
      end
    @user.skip_password_validation = true
    @identity.user = @user if @identity.new_record?
  end

  def save_success?
    @user.save && @identity.save
  end

  def connect_success_action
    flash[:toast] = { type: 'success', message: ['Account Connected'] }
    redirect_to settings_users_path
  end

  def sign_in_success_action
    sign_in(:user, @user)
    redirect_to after_sign_in_path_for(@user)
  end

  def fail_action
    flash[:toast] = { type: 'error', message: @user.errors.full_messages }
    redirect_to new_user_registration_url
  end
end
