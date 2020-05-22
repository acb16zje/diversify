# frozen_string_literal: true

class Projects::TeamsController < ApplicationController
  before_action :set_team, only: %i[edit show update destroy remove_user]
  before_action :set_project, except: %i[show update remove_user]
  before_action :set_skills, only: %i[new edit]

  layout 'project'

  def manage_data
    extend TeamHelper

    return render_404 unless request.xhr?

    @data =
      User.joins('LEFT OUTER JOIN task_users ON task_users.user_id = users.id')
          .joins('LEFT OUTER JOIN tasks ON tasks.id = task_users.task_id AND tasks.percentage != 100')
          .joins(:teams).where(teams: { project: @project })
          .select('users.*, teams.id as team_id, COUNT(tasks.id) as count')
          .group('users.id, teams.id')

    render json: {
      compability: @data.map { |u|
        [u.id, compability(u, @project.teams, @project.unassigned_team.id)]
      }.to_h,
      data: @data.group_by(&:team_id),
      teams: @project.teams&.select(:id, :name, :team_size)
    }
  end

  def save_manage
    Oj.load(params[:data]).each do |selected_team_id, members|
      new_team = Team.find(selected_team_id.to_i)
      members.each do |member|
        next unless member['team_id'] != selected_team_id.to_i

        change_team(member, new_team)
      end
    end
    head :ok
  end

  def recompute
    extend TeamHelper

    return render_404 unless request.xhr?

    data = {}
    input = Oj.load(params[:data])
    input.each do |selected_team_id, members|
      team = @project.teams.where(id: selected_team_id).first
      next if members.blank? || team.blank?

      local = recompute_team(@project.teams, @project.unassigned_team, team, input).to_h
      data = data.merge(local)
    end
    render json: { compability: data }
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
    @project = Project.find(params[:project_id])
  end

  def show
    return render_404 unless request.xhr?

    render json: {
      name: @team.name,
      skills: @team.skills&.select(:id, :name),
      teamSize: @team.team_size,
      memberCount: @team.users.size
    }
  end

  # POST /teams
  def create
    @team = @project.teams.build(create_params)

    if @team.save
      @team.skill_ids = params[:team][:skill_ids]
      team_success('Team was successfully created')
    else
      team_fail
    end
  end

  # PATCH/PUT /teams/1
  def update
    @team.update(edit_params) ? team_success('Team Saved') : team_fail
  end

  # DELETE /teams/1
  def destroy
    @project.unassigned_team.users << @team.users
    @team.destroy
    head :ok
  end

  def remove_user
    user = User.find(params[:user_id])

    return team_fail('Cannot remove owner') if user == @team.project.user

    @team.users.delete(user)
    head :ok
  end

  private

  def set_team
    @team = Team.find(params[:id])
    authorize! @team
  end

  def set_skills
    @skills = @project.category.skills.map { |s| [s.name, s.id] }
  end

  def set_project
    @project = Project.find(params[:project_id])
    authorize! @project, to: :manage?
  end

  def create_params
    params.require(:team)
          .except(:skill_ids)
          .permit(:team_size, :name)
  end

  def edit_params
    params.require(:team).permit(:team_size, :name, skill_ids: [])
  end

  def team_success(message)
    flash[:toast_success] = message
    render js: "window.location = '#{manage_project_teams_path(@team.project)}'"
  end

  def team_fail(message = @team.errors.full_messages)
    render json: { message: message }, status: :unprocessable_entity
  end

  def change_team(member, new_team)
    user = User.find(member['id'])
    old_team = Team.find(member['team_id'])
    authorize! old_team
    authorize! new_team
    new_team.users << user
    old_team.users.delete(user)
  end
end
