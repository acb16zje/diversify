# frozen_string_literal: true

# Controller for projects
class ProjectsController < ApplicationController
  include ProjectsQuery

  before_action :set_project, except: %i[index self query new create]
  skip_before_action :authenticate_user!, only: %i[index show query]
  before_action :set_project, only: %i[show]

  layout 'user'

  # GET /projects
  def index
    @categories = Category.all
  end

  def query
    return head :bad_request unless valid_page?

    scope = authorized_scope(call(params))
    pagy, records = pagy(scope, page: params[:page])

    render json: { data: records, pagy: pagy_metadata(pagy),
                   images: project_images(records) }
  end

  # GET /projects/1
  def show
    @invites = User.select(:id, :name).joins(:invites)
                   .where(invites: { types: 'Invite', project: @project })
    @applications = User.select(:id,:name).joins(:invites)
                        .where(invites:
                        {
                          types: 'Application', project: @project
                        })
  end

  def self
    @categories = Category.all
    @owned_projects = Project.where(user: current_user)
  end

  # GET /projects/new
  def new; end

  # POST /projects
  def create
    @project = Project.new(project_params)
    @project.user = current_user
    @project.save ? project_success('Project Created') : project_fail(nil)
  end

  # PATCH/PUT /projects/1
  def update
    return project_fail('Bad Request') if
      params[:project].key?(:visibility) && current_user.license.plan == 'free'

    if @project.update(project_params)
      project_success('Project Updated')
    else
      project_fail(nil)
    end
  end

  def change_status
    return project_fail('Invalid Status Change') if
      @project.status != 'Active' && params[:status] != 'Active'

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

  def valid_page?
    params[:page].to_i.positive? &&
      %w[projects joined owned].include?(params[:type])
  end

  def project_images(records)
    images = {}
    records.each do |record|
      next unless record.avatar.attached?

      images[record.id] = url_for(record.avatar.variant(resize: '100x100!'))
    end
    images
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
    when 'Completed' then 'Project Archived'
    when 'Active'
      @project.invites.where(types: 'Application').destroy_all
      @project.status == 'Completed' ? 'Project Activated' : 'Project Closed'
    when 'Open' then 'Project Opened'
    end
  end
end
