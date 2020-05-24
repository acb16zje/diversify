# frozen_string_literal: true

class Projects::Teams::BaseController < ApplicationController
  layout 'project'

  private

  def set_team
    @team = Team.find(params[:id])
    authorize! @team
  end

  def set_skills
    @skills = Skill.where(category: @project.category)
                   .collect { |s| [s.name, s.id] }
  end

  def set_project
    @project = Project.find(params[:project_id])
    authorize! @project, to: :manage?
  end

  def team_success(message)
    flash[:toast_success] = message
    render js: "window.location = '#{project_manage_index_path(@project)}'"
  end

  def team_fail(message = @team.errors.full_messages)
    render json: { message: message }, status: :unprocessable_entity
  end
end
