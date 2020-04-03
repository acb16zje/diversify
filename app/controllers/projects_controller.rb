# frozen_string_literal: true

# Controller for projects
class ProjectsController < ApplicationController
  include ProjectsQuery

  before_action :set_project, except: %i[index self query new create]
  before_action :set_category, only: %i[index self]
  skip_before_action :authenticate_user!, only: %i[index show query]

  layout 'user'

  # GET /projects
  def index; end

  def query
    return head :bad_request unless valid_page?

    scope = authorized_scope(call(params))
    pagy, records = pagy(scope, page: params[:page])

    render json: { data: records, pagy: pagy_metadata(pagy),
                   images: project_images(records) }
  end

  # GET /projects/1
  def show
    @invites = User.relevant_invite('Invite', @project)
    @applications = User.relevant_invite('Application', @project)
  end

  def self
    @owned_projects = Project.where(user: current_user)
  end

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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
    authorize! @project
  end

  # Only allow a trusted parameter "white list" through.
  def project_params
    params.require(:project).permit(
      :name, :description, :visibility, :category_id, :avatar
    )
  end

  def set_category
    @categories = Category.all
  end

  def valid_project?
    params[:project].key?(:visibility) &&
      !current_user.can_change_visibility?
  end

  def valid_page?
    params[:page].to_i.positive? &&
      %w[projects joined owned].include?(params[:type])
  end

  def project_success(message)
    flash[:toast_success] = message
    render js: "window.location = '#{project_path(@project)}'"
  end

  def project_fail(message)
    message ||= @project.errors.full_messages
    render json: { message: message },
           status: :unprocessable_entity
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
