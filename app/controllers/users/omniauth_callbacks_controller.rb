# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  def google_oauth2
    auth = request.env['omniauth.auth']
    identity = Identity.where(provider: auth['provider'],
                uid: auth['uid']).first_or_create
    user = 
      if !user_signed_in? && identity.new_record?
        User.new(
          email: auth['info']['email'],
          name:  auth['info']['name'],
          password: ""
        )
      elsif user_signed_in?
        current_user
      else
        identity.user
      end
    user.skip_password_validation = true
    identity.user = user if identity.new_record?
    if user.save && identity.save
      sign_in(:user, user)
      redirect_to after_sign_in_path_for(user)
    else
      redirect_to new_user_registration_url
    end
  end

  def twitter
    auth = request.env['omniauth.auth']
    identity = Identity.where(provider: auth['provider'],
                uid: auth['uid']).first_or_create
    user = 
      if !user_signed_in? && identity.new_record?
        User.new(
          email: auth['info']['email'],
          name:  auth['info']['name'],
          password: ""
        )
      elsif user_signed_in?
        current_user
      else
        identity.user
      end
    user.skip_password_validation = true
    identity.user = user if identity.new_record?
    if user.save && identity.save
      sign_in(:user, user)
      redirect_to after_sign_in_path_for(user)
    else
      session['devise.twitter_data'] = auth.except('extra')
      redirect_to new_user_registration_url
    end
  end

  def facebook
    auth = request.env['omniauth.auth']
    identity = Identity.where(provider: auth['provider'],
                uid: auth['uid']).first_or_create
    user = 
      if !user_signed_in? && identity.new_record?
        User.new(
          email: auth['info']['email'],
          name:  auth['info']['name'],
          password: ""
        )
      elsif user_signed_in?
        current_user
      else
        identity.user
      end
    user.skip_password_validation = true
    identity.user = user if identity.new_record?
    if user.save && identity.save
      sign_in(:user, user)
      redirect_to after_sign_in_path_for(user)
    else
      session['devise.facebook_data'] = auth.except('extra')
      redirect_to new_user_registration_url
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

  def sign_up?(provider, uid)
    !user_signed_in? && !Identity.exists?(provider: provider, uid: uid)
  end
end
