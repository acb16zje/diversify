# frozen_string_literal: true

class Projects::TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]
  before_action :set_project
  before_action :set_skills, only: %i[new edit]

  layout 'project'

  # GET /tasks
  def index
    @tasks = Task.all
  end

  # GET /tasks/1
  def show; end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit; end

  # POST /tasks
  def create
    @task = Task.new(create_params)
    @task.user = current_user

    if @task.save
      @task.skill_ids = params[:task][:skills_id].drop(1)
      @task.user_ids =  params[:task][:users_id].drop(1)
      task_success('Task created')
    else
      task_fail(nil)
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(edit_params)
      task_success('Task updated')
    else
      task_fail(nil)
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
    redirect_to tasks_url, notice: 'Task was successfully destroyed.'
  end

  def data
    return unless request.xhr?

    user_data = Task.joins(:users).where(project: @project)
                    .select('tasks.id,
                            users.id as user_id, users.name as user_name')
    @data = Task.joins(:user).where(project: @project)
                .select('tasks.*, users.name as owner_name, users.id as owner_id')
    images = assignee_avatars(User.find(user_data.pluck(:user_id).uniq))
    user_data = user_data.group_by(&:id)

    render json: { data: @data, user_data: user_data,
                   images: images }, status: :ok
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_skills
    @skills = Skill.where(category: @project.category)
                   .collect { |s| [s.name, s.id] }
    # TODO: Scoping for users
    @assignees = @project.users.collect { |s| [s.name, s.id] }
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  def task_fail(message)
    message ||= @task.errors.full_messages
    render json: { message: message }, status: :unprocessable_entity
  end

  def task_success(message)
    flash[:toast_success] = message
    render js: "window.location = '#{project_path(@task.project)}'"
  end

  # Only allow a trusted parameter "white list" through.
  def create_params
    params.require(:task).except(:skills_id, :users_id)
          .permit(:project_id, :name, :description)
  end

  def edit_params
    params.require(:task)
          .permit(:description, :project_id, :name, skill_ids: [], user_ids: [])
  end

  def assignee_avatars(users)
    extend AvatarHelper

    images = {}
    users.each do |u|
      images[u.id] =
        u.avatar.attached? ? url_for(user_avatar(u)) : user_avatar(u)
    end
    images
  end
end
