# frozen_string_literal: true

# Controller for setting user personality
class Users::Settings::PersonalitiesController < Users::Settings::BaseController
  before_action :prepare_user_personality, only: %i[show update]

  def show
    render 'users/settings/personalities'
  end

  def update
    @user_p.personality = Personality.find_by(personalities_params)
    if @user_p.save
      update_success
    else
      render json: { message: 'Invalid Personality' },
             status: :unprocessable_entity
    end
  end

  private

  def personalities_params
    params.require(:personality).permit(:mind, :energy, :nature, :tactic)
  end

  def prepare_user_personality
    @user_p =
      if current_user.user_personality.nil?
        UserPersonality.new(user: current_user)
      else
        current_user.user_personality
      end
  end

  def update_success
    flash[:toast_success] = 'Personality Updated'
    render js: "window.location = '#{settings_personality_path}'"
  end
end
