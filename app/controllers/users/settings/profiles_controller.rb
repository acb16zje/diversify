# frozen_string_literal: true

class Users::Settings::ProfilesController < Users::Settings::BaseController
  def show
    render 'users/settings/profile'
  end

  def update
    if current_user.update(profile_params)
      render json: { message: 'Profile updated' }
    else
      render json: { message: current_user.errors.full_messages }, status: :bad_request
    end
  end

  def remove_avatar
    return head :not_found unless current_user.avatar.attached?

    current_user.avatar.purge_later

    redirect_to settings_profile_path, status: :found
  end

  private

  def profile_params
    params.require(:user).permit(:name, :avatar, :birthdate)
  end
end
