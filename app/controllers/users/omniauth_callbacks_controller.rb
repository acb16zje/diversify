# frozen_string_literal: true

# controller for OAuth Devise
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def omniauth_flow
    user_signed_in? ? connect_flow : sign_in_flow

    return unless @user&.persisted?

    user_signed_in? ? connect_success_action : sign_in_success_action
  end

  Devise.omniauth_providers.each do |provider|
    alias_method provider, :omniauth_flow
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

  def sign_in_flow
    identity = User.sign_in_omniauth(request.env['omniauth.auth'])

    errors = identity.errors.full_messages + identity.user.errors.full_messages

    if errors.blank?
      @user = identity.user
      unless @user.avatar.attached?
        downloaded_image = open(request.env['omniauth.auth'].info.image)
        @user.avatar.attach(io: downloaded_image, filename: 'foo.jpg')
      end
    else
      flash[:toast] = { type: 'error', message: errors }
      redirect_to new_user_registration_url
    end
  end

  def connect_flow
    identity = User.connect_omniauth(request.env['omniauth.auth'], current_user)
    if identity.errors.blank?
      @user = identity.user
    else
      flash[:toast] = { type: 'error', message: identity.errors.full_messages }
      redirect_to settings_users_path
    end
  end

  def connect_success_action
    flash[:toast] = { type: 'success', message: ['Account Connected'] }
    redirect_to settings_users_path
  end

  def sign_in_success_action
    sign_in @user
    redirect_to after_sign_in_path_for(@user)
  end
end
