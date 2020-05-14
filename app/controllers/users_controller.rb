# frozen_string_literal: true

# Controller for users
class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: :show

  layout 'user'

  def show
    @user = User.find(params[:id])
    render_projects(params[:joined].present? ? :profile_joined : :profile_owned)
    @skills = UserSkill.joins(skill: :category).where(user_id: @user.id)
                       .select('user_skills.created_at')
                       .select('skills.name AS name')
                       .select('categories.name AS category_name')
  end

  private

  def render_projects(policy_scope)
    @pagy, projects = pagy(authorized_scope(
                             Project.search(params),
                             as: policy_scope,
                             scope_options: { target: @user }
                           ))
    @html = view_to_html_string('projects/_projects', projects: projects)

    respond_to do |format|
      format.html
      format.json { render json: { html: @html, total: @pagy.count } }
    end
  end
end
