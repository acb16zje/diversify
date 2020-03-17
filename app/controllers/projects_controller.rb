# frozen_string_literal: true

# Controller for projects
class ProjectsController < ApplicationController
  include ProjectsQuery

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
    render json: { data: records, pagy: pagy_metadata(pagy) }
  end

  # GET /projects/1
  def show
    authorize! @project
  end

  def self
    @categories = Category.all
    @owned_projects = Project.where(user: current_user)
  end

  # GET /projects/new
  # def new
  #   @project = Project.new
  # end

  # GET /projects/1/edit
  # def edit; end

  # POST /projects
  def create
    project = Project.new(project_params)
    project.user = current_user

    if project.save!
      flash[:toast] = { type: 'success', message: ['Project Created'] }
      render js: "window.location = '#{project_path(project)}'"
    else
      render json: { message: 'Project Creation Failed' },
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/1
  # def update
  #   if @project.update(project_params)
  #     redirect_to @project, notice: 'Project was successfully updated.'
  #   else
  #     render :edit
  #   end
  # end

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

  # Only allow a trusted parameter "white list" through.
  def project_params
    params.require(:project).permit(:name, :description, :visibility, :category_id)
  end

  def valid_page?
    params[:page].to_i.positive? &&
      %w[projects joined owned].include?(params[:type])
  end
end
