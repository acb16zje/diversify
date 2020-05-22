# frozen_string_literal: true

class Users::Settings::SkillsController < Users::Settings::BaseController
  def show
    @skills = current_user.skills.with_category('category_name ASC, name ASC')
    render 'users/settings/skills'
  end

  def create
    # insert_all does not trigger validations, handle the errors on client-side
    records = UserSkill.insert_all(
      skill_params[:skill_ids].map do |id|
        { user_id: current_user.id, skill_id: id }
      end
    )

    if skill_params[:skill_ids].length == records.length
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def destroy
    user_skill = current_user.user_skills.find_by!(skill_id: params[:skill_id])
    user_skill.delete ? head(:ok) : head(:bad_request)
  end

  private

  def skill_params
    params.require(:skill).permit(skill_ids: [])
  end
end
