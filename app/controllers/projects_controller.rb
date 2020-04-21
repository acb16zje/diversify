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
    return project_fail('Bad Request') if valid_project?

    @project = current_user.projects.build(project_params)
    @project.save ? project_success('Project Created') : project_fail
  end

  # PATCH/PUT /projects/1
  def update
    return project_fail('Bad Request') if valid_project?

    if @project.update(project_params)
      project_success('Project Updated')
    else
      project_fail
    end
  end

  # TODO: cannot change to open when project is private, use callback for project_fail check
  def change_status
    @project.update(status: params[:status])
    msg = @project.errors.full_messages

    msg.blank? ? project_success(prepare_message) : project_fail(msg)
  end

  def count
    return head :bad_request unless
    params.key?(:type) && %w[task team application].include?(params[:type])

    count = case params[:type]
            when 'task' then @project.tasks.size
            when 'team' then 0
            when 'application' then @project.appeals.size
            end

    render json: { count: count }
  end

  private

  def set_project
    @project = Project.find(params[:id])
    authorize! @project, with: ProjectPolicy
  end

  def project_params
    params
      .require(:project)
      .permit(%i[name description visibility category_id avatar])
  end

  def render_projects(policy_scope)
    @pagy, projects = pagy(authorized_scope(Project.search(params),
                                            as: policy_scope))
    @html = view_to_html_string('projects/_projects', projects: projects)

    respond_to do |format|
      format.html
      format.json { render json: { html: @html, total: @pagy.count } }
    end
  end

  def valid_project?
    params[:project].key?(:visibility) && !current_user.can_change_visibility?
  end

  def project_success(message)
    @project.appeals.delete_all if @project.completed?
    flash[:toast_success] = message
    render js: "window.location = '#{project_path(@project)}'"
  end

  def project_fail(message = @project.errors.full_messages)
    render json: { message: message }, status: :unprocessable_entity
  end

  def prepare_message
    case params[:status]
    when 'completed'
      'Project Archived'
    when 'active'
      @project.appeals.where(type: 'application').destroy_all
      @project.completed? ? 'Project Activated' : 'Project Closed'
    when 'open'
      'Project Opened'
    end
  end
end
