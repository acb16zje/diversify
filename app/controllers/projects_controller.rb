# frozen_string_literal: true

# Controller for projects
class ProjectsController < ApplicationController
  include ProjectsQuery

  before_action :set_project, except: %i[index self query new create]
  before_action :authorize_project, except: %i[index self show query new create]
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
    images = project_images(records)

    render json: { data: records, pagy: pagy_metadata(pagy), images: images }
  end

  # GET /projects/1
  def show
    authorize! @project
    @invites = User.select(:id,:name).joins(:applications)
                   .where(applications: { types: 'Invite', project: @project })
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
    @project.save ? project_success('Project Created') : project_fail
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      project_success('Project Updated')
    else
      project_fail
    end
  end

  def complete
    @project.status = 'Completed'
    @project.save ? project_success('Project Archived') : project_fail
  end

  def uncomplete
    @project.status = 'Active'
    @project.save ? project_success('Project Reactivated') : project_fail
  end

  def open_application
    @project.status = 'Open'
    @project.save ? project_success('Applications Opened') : project_fail
  end

  def close_application
    @project.status = 'Active'
    @project.save ? project_success('Application Closed') : project_fail
  end

  # DELETE /projects/1
  # def destroy
  #   @project.destroy
  #   redirect_to projects_url, notice: 'Project was successfully destroyed.'
  # end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  end

  def authorize_project
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
      if record.avatar.attached?
        images[record.id] = url_for(record.avatar.variant(resize: '100x100!'))
      end
    end
    images
  end

  def project_success(message)
    flash[:toast] = { type: 'success', message: [message] }
    render js: "window.location = '#{project_path(@project)}'"
  end

  def project_fail
    render json: { message: @project.errors.full_messages },
           status: :unprocessable_entity
  end
end
