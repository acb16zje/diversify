# frozen_string_literal: true

# Controller for projects
class ProjectsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[explore show]

  before_action :set_project, except: %i[index explore new create]

  layout 'project'

  # GET /projects
  def index
    render_projects(params[:personal].present? ? :own : :joined)
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

    @project = Project.new(project_params)
    @project.user = current_user
    @project.save ? project_success('Project Created') : project_fail(nil)
  end

  # PATCH/PUT /projects/1
  def update
    return project_fail('Bad Request') if valid_project?

    if @project.update(project_params)
      project_success('Project Updated')
    else
      project_fail(nil)
    end
  end

  def change_status
    return project_fail('Invalid Status Change') if
      @project.status != 'Active' && params[:status] != 'active'

    message = prepare_message
    @project.status = params[:status]
    @project.save ? project_success(message) : project_fail(nil)
  end

  def count
    return head :bad_request unless
    params.key?(:type) && %w[task team application].include?(params[:type])

    count = case params[:type]
    when 'task'
      @project.tasks.size
    when 'team'
      0
    when 'application'
      @project.invites.size
    end

    render json: { count: count }, status: :ok
  end

  def data
    return head :bad_request unless
    params.key?(:types) && %w[Invite Application].include?(params[:types])

    render json: { data: User.relevant_invite(params[:types], @project) },
           status: :ok
  end

  private

  def set_project
    @project = Project.find(params[:id])
    authorize! @project, with: ProjectPolicy
  end

  def project_params
    params.require(:project).permit(
      :name, :description, :visibility, :category_id, :avatar
    )
  end

  def render_projects(policy_scope)
    @pagy, projects = pagy(
      authorized_scope(Project.search(params), as: policy_scope),
      page: params[:page]
    )
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
    flash[:toast_success] = message
    render js: "window.location = '#{project_path(@project)}'"
  end

  def project_fail(message)
    message ||= @project.errors.full_messages
    render json: { message: message }, status: :unprocessable_entity
  end

  def prepare_message
    case params[:status]
    when 'completed' then 'Project Archived'
    when 'active'
      @project.invites.where(types: 'Application').destroy_all
      @project.status == 'completed' ? 'Project Activated' : 'Project Closed'
    when 'open' then 'Project Opened'
    end
  end
end
