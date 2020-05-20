# frozen_string_literal: true

# Controller for projects
class ProjectsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[explore show]

  before_action :set_project, except: %i[index explore new create]

  layout 'project'

  # GET /projects
  def index
    render_projects(params[:joined].present? ? :joined : :own)
  end

  def explore
    render_projects(:explore)
  end

  # GET /projects/1
  def show; end

  # GET /projects/new
  def new; end

  # POST /projects
  def create
    @project = current_user.projects.build(project_params)
    @project.save ? project_success('Project Created') : project_fail
  end

  # PATCH/PUT /projects/1
  def update
    return project_fail unless @project.update(project_params)

    project_success('Project Updated')
  end

  def change_status
    msg = case params[:status]
          when 'completed'
            'Project Archived'
          when 'active'
            @project.appeals.application.destroy_all
            @project.completed? ? 'Project Activated' : 'Project Closed'
          when 'open'
            'Project Opened'
          end

    @project.update(status: params[:status]) ? project_success(msg) : project_fail
  end

  def count
    return head :bad_request unless %w[task application].include?(params[:type])

    render json: {
      count: case params[:type]
             when 'task' then @project.tasks.where('percentage < 100').size
             when 'application' then @project.appeals.size
             end
    }
  end

  private

  def set_project
    @project = Project.includes(:teams, :users, :tasks)
                      .find(params[:id])
    authorize! @project, with: ProjectPolicy
  end

  def project_params
    params.require(:project).permit(%i[name description visibility category_id avatar])
  end

  def render_projects(policy_scope)
    @pagy, projects = pagy(authorized_scope(Project.search(params), as: policy_scope))
    @html = view_to_html_string('projects/_projects', projects: projects)

    respond_to do |format|
      format.html
      format.json { render json: { html: @html, total: @pagy.count } }
    end
  end

  def project_success(message)
    @project.appeals.delete_all if @project.completed?
    flash[:toast_success] = message
    render js: "window.location = '#{project_path(@project)}'"
  end

  def project_fail(message = @project.errors.full_messages)
    render json: { message: message }, status: :unprocessable_entity
  end
end
