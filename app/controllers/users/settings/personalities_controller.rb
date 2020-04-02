# frozen_string_literal: true

# Controller for setting user personality
class Users::Settings::PersonalitiesController < Users::Settings::BaseController
  def show
    @personality = current_user.personality || Personality.new
    render 'users/settings/personalities'
  end

  def update
    # Invalid input will by rescued by StatementInvalid in ApplcationController
    current_user.update(personality: Personality.find_by(personality_params))

    flash[:toast_success] = 'Personality Updated'
    render js: "window.location = '#{settings_personality_path}'"
  end

  private

  def personality_params
    params.require(:personality).permit(:mind, :energy, :nature, :tactic)
  end
end
