# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  def google_oauth2
    auth = request.env["omniauth.auth"]
    user = User.where(provider: auth["provider"], uid: auth["uid"])
            .first_or_initialize(email: auth["info"]["email"], name: auth["info"]["name"])
    user.password =  Devise.friendly_token[0,20]
    user.save!

    user.remember_me = true
    sign_in(:user, user)

    redirect_to after_sign_in_path_for(user)
  end

  def twitter
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    auth = request.env["omniauth.auth"]
    user = User.where(provider: auth.provider, uid: auth.uid)
            .first_or_initialize(email: auth.info.email, name: auth.info.name)
    user.password =  Devise.friendly_token[0,20]

    if user.save
      user.remember_me = true
      sign_in(:user, user)

      redirect_to after_sign_in_path_for(user)
      # sign_in_and_redirect user, event: :authentication #this will throw if user is not activated
      # set_flash_message(:notice, :success, kind: "Twitter") if is_navigational_format?
    else
      session["devise.twitter_data"] = auth.except("extra")
      redirect_to new_user_registration_url
    end
  end

  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    auth = request.env["omniauth.auth"]
    user = User.where(provider: auth.provider, uid: auth.uid)
            .first_or_initialize(email: auth.info.email, name: auth.info.name)
    user.password =  Devise.friendly_token[0,20]

    if user.save
      user.remember_me = true
      sign_in(:user, user)

      redirect_to after_sign_in_path_for(user)
      # sign_in_and_redirect user, event: :authentication #this will throw if user is not activated
      # set_flash_message(:notice, :success, kind: "Twitter") if is_navigational_format?
    else
      session["devise.facebook_data"] = auth.except("extra")
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
end
