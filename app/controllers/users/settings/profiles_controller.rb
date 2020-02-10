# frozen_string_literal: true

class Users::Settings::ProfilesController < Users::Settings::BaseController
  def show
    render 'users/settings/profile'
  end

  def update
    if current_user.update(user_params)
      render json: { message: 'Profile updated' }
    else
      render json: { message: current_user.errors.full_messages }, status: :bad_request
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :avatar, :birthdate)
  end
end
