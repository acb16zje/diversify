# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  def google_oauth2
    auth = request.env['omniauth.auth']
    identity = Identity.where(provider: auth['provider'],
                uid: auth['uid']).first_or_create
    if user_signed_in? && !identity.new_record?
      flash[:toast] = { type: 'error', message: ['This account has been taken'] }
      return redirect_to settings_users_path  
    end
    user =
      if user_signed_in?
        current_user
      else
        User.where(id: identity.user_id).first_or_create(
          email: auth['info']['email'],
          name:  auth['info']['name']
        )
      end
    user.skip_password_validation = true
    identity.user = user if identity.new_record?
    if user.save && identity.save
      sign_in(:user, user)
      redirect_to after_sign_in_path_for(user)
    else
      flash[:toast] = { type: 'error', message: user.errors.full_messages }
      redirect_to new_user_registration_url
    end
  end

  def twitter
    auth = request.env['omniauth.auth']
    identity = Identity.where(provider: auth['provider'],
                uid: auth['uid']).first_or_create
    if user_signed_in? && !identity.new_record?
      flash[:toast] = { type: 'error', message: ['This account has been taken'] }
      return redirect_to settings_users_path  
    end
    user =
      if user_signed_in?
        current_user
      else
        User.where(id: identity.user_id).first_or_create(
          email: auth['info']['email'],
          name:  auth['info']['name']
        )
      end
    user.skip_password_validation = true
    identity.user = user if identity.new_record?
    if user.save && identity.save
      if user_signed_in?
        flash[:toast] = { type: 'success', message: ['Account Connected'] }
        redirect_to settings_users_path
      else
        sign_in(:user, user)
        redirect_to after_sign_in_path_for(user)
      end
    else
      session['devise.twitter_data'] = auth.except('extra')
      flash[:toast] = { type: 'error', message: user.errors.full_messages }
      redirect_to new_user_registration_url
    end
  end

  def facebook
    auth = request.env['omniauth.auth']
    identity = Identity.where(provider: auth['provider'],
                uid: auth['uid']).first_or_create
    if user_signed_in? && !identity.new_record?
      flash[:toast] = { type: 'error', message: ['This account has been taken'] }
      return redirect_to settings_users_path  
    end

    user =
      if user_signed_in?
        current_user
      else
        User.where(id: identity.user_id).first_or_create(
          email: auth['info']['email'],
          name:  auth['info']['name']
        )
      end
    user.skip_password_validation = true
    identity.user = user if identity.new_record?
    if user.save && identity.save
      if user_signed_in?
        flash[:toast] = { type: 'success', message: ['Account Connected'] }
        redirect_to settings_users_path
      else
        sign_in(:user, user)
        redirect_to after_sign_in_path_for(user)
      end
    else
      session['devise.facebook_data'] = auth.except('extra')
      flash[:toast] = { type: 'error', message: user.errors.full_messages }
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
