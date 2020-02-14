# frozen_string_literal: true

# Controller for projects
class ProjectsController < ApplicationController
  include ProjectsQuery

  before_action :set_project, only: %i[show edit update destroy]
  skip_before_action :authenticate_user!, only: %i[index show query]

  layout 'user'

  # GET /projects
  def index
    @categories = Category.all
  end

  def query
    return render json: {}, status: :bad_request unless valid_page?

    scope = authorized_scope(call(params))

    pagy, records = pagy(scope, page: params[:page])
    render json: { data: records, pagy: pagy_metadata(pagy) }
  end

  # GET /projects/1
  def show
    authorize! @project
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit; end

  # POST /projects
  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy
    redirect_to projects_url, notice: 'Project was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def project_params
    params.fetch(:project, {})
  end

  def valid_page?
    params[:page].to_i > 0
  end
end
