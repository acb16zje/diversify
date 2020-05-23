# frozen_string_literal: true

class Projects::TasksController < ApplicationController
  before_action :set_task,
                only: %i[edit update set_percentage assign_self destroy]
  before_action :set_project,
                except: %i[update destroy assign_self set_percentage]
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
    @task = @project.tasks.build(create_params)

    if @task.save
      @task.skill_ids = params.dig(:task, :skill_ids)
      @task.user_ids =  params.dig(:task, :user_ids)
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
    @task.send_picked_up_notification
    head :ok
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
    head :ok
  end

  def data
    extend AvatarHelper

    return render_404 unless request.xhr? && valid_data_type?

    render json: {
      data: TaskBlueprint.render_as_json(
        authorized_scope(@project.tasks, as: @type).includes(users: [{ avatar_attachment: :blob }])
      )
    }
  end

  def set_percentage
    @task.update(edit_params) ? head(:ok) : task_fail
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_skills
    @skills = @project.category.skills.map { |s| [s.name, s.id] }

    team = current_user.teams.find_by(project: @project)
    @assignees = authorized_scope(
      @project.users,
      as: :assignee,
      scope_options: { team_id: team&.id, project: @project }
    )
  end

  def set_task
    @task = Task.find(params[:id])
    authorize! @task
  end

  def create_params
    params.require(:task)
          .except(:skill_ids, :user_ids)
          .permit(:name, :description, :priority)
          .merge(user: current_user)
  end

  def edit_params
    params.require(:task).permit(:description, :name,
                                 :percentage, :priority,
                                 skill_ids: [], user_ids: [])
  end

  def task_fail(message = @task.errors.full_messages)
    render json: { message: message }, status: :unprocessable_entity
  end

  def task_success(message)
    flash[:toast_success] = message
    render js: "window.location = '#{project_path(@task.project)}'"
  end

  def valid_data_type?
    authorize! @project, to: :count?

    @type = params[:type]&.to_sym
    %i[assigned unassigned active completed].include?(@type)
  end
end
