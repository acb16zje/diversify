# frozen_string_literal: true

# Controller for handling user sessions
class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate(auth_options)

    if resource
      sign_in(resource_name, resource)
      yield resource if block_given?
      render js: "window.location='#{after_sign_in_path_for(resource)}'"
    else
      set_flash_message(:errors, :invalid)
      render json: { message: flash[:errors] }, status: :unauthorized
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
