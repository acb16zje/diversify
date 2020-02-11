# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]

  layout 'user'

  # GET /projects
  def index
    @categories = Category.all
  end

  def query
    return render json:{},status: :bad_request unless params[:page].to_i.is_a? Numeric
    params.delete_if {|key, value| value.blank? }
    order = sort_items(params[:sort])
    @pagy, @records = pagy(Project.where(search_params)
      .where('name LIKE ?', "%#{params[:name]}%").order(order),
      items: 10, page: params[:page])
    render json: { data: @records,
              pagy: pagy_metadata(@pagy) }
  end

  # GET /projects/1
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

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

  def search_params
    params.except(:page, :sort,:name).permit(:status, :category).delete_if {|key, value| value.blank? }
  end

  def sort_items(order)
    puts "ORDER #{order}"
    case order
    when 'name_asc'
      return 'name asc'
    when 'name_desc'
      return 'name desc'
    when 'date_asc'
      return 'created_at asc'
    when 'date_desc'
      return 'created_at desc'
    else
      return 'name asc'
    end
  end
end
