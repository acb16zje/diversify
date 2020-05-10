# frozen_string_literal: true

class Projects::TasksController < ApplicationController
  before_action :set_task,
                only: %i[edit update set_percentage assign_self destroy]
  before_action :set_project, except: :set_percentage
  before_action :set_skills, only: %i[new edit]

  layout 'project'

  # GET /tasks/new
  def new
    @task = Task.new(project: @project)
    authorize! @project, to: :create_task?
  end

  # GET /tasks/1/edit
  def edit; end

  # POST /tasks
  def create
    authorize! @project, to: :create_task?
    @task = Task.new(create_params)

    @task.user = current_user

    if @task.save
      @task.skill_ids = params.dig(:task, :skills_id)&.drop(1)
      @task.user_ids =  params.dig(:task, :users_id)&.drop(1)
      task_success('Task created')
    else
      task_fail
    end
  end

  # PATCH/PUT /tasks/1
  def update
    @task.update(edit_params) ? task_success('Task updated') : task_fail
  end

  def assign_self
    return task_fail('Task is already Assigned') if @task.users.present?

    @task.users << current_user
    head :ok
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
    head :ok
  end

  def data
    authorize! @project, to: :count?
    return render_404 unless request.xhr? && valid_data_type?

    scope_data = authorized_scope(Task.where(project: @project), as: @type)

    user_data = scope_data.user_data
    images = assignee_avatars(user_data.pluck('users.id').uniq)
    user_data = user_data.group_by(&:id)

    render json: { data: scope_data.data, user_data: user_data,
                   images: images }, status: :ok
  end

  def set_percentage
    if @task.update(edit_params)
      head :ok
    else
      task_fail
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_skills
    @skills = Skill.where(category: @project.category)
                   .collect { |s| [s.name, s.id] }

    team = current_user.teams.find_by(project: @project)
    @assignees = authorized_scope(
      @project.users,
      as: :assignee, scope_options: { team_id: team&.id, project: @project }
    )
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
    authorize! @task
  end

  def task_fail(message = @task.errors.full_messages)
    render json: { message: message }, status: :unprocessable_entity
  end

  def task_success(message)
    flash[:toast_success] = message
    render js: "window.location = '#{project_path(@task.project)}'"
  end

  # Only allow a trusted parameter "white list" through.
  def create_params
    params.require(:task).except(:skills_id, :users_id)
          .permit(:project_id, :name, :description, :priority)
  end

  def edit_params
    params.require(:task)
          .permit(:description, :project_id, :name, :percentage, :priority,
                  skill_ids: [], user_ids: [])
  end

  def assignee_avatars(ids)
    extend AvatarHelper

    arr = {}
    User.find(ids).each do |u|
      arr[u.id] = u.avatar.attached? ? url_for(user_avatar(u)) : user_avatar(u)
    end
    arr
  end

  def valid_data_type?
    @type = params[:type]&.to_sym
    %i[assigned unassigned active completed].include?(@type)
  end
end
