# frozen_string_literal: true

# Controller for registration and update password
class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    resource.persisted? ? register_success : register_fail
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    if form_filled?
      resource_updated = oauth_update_resource
      yield resource if block_given?
      resource_updated ? update_success : register_fail
    else
      render json: { message: 'Please fill in the form' }, status: :bad_request
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  #   root_path
  # end

  private

  def form_filled?
    params[:user][:password].present? &&
      params[:user][:password_confirmation].present?
  end

  def register_success
    sign_up(resource_name, resource)
    render js: "window.location='#{root_path}'"
  end

  def update_success
    if sign_in_after_change_password?
      bypass_sign_in resource, scope: resource_name
    end

    flash[:toast] = { type: 'success', message: ['Password Changed'] }
    render js: "window.location='#{settings_account_path}'"
  end

  def register_fail
    clean_up_passwords resource
    set_minimum_password_length
    render json: { message: resource.errors.full_messages },
           status: :bad_request
  end

  def oauth_update_resource
    if resource.password_automatically_set?
      resource.update(account_update_params)
    else
      update_resource(resource, account_update_params)
    end
  end
end
