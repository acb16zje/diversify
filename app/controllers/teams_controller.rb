# frozen_string_literal: true

class TeamsController < ApplicationController
  before_action :set_team, only: %i[edit update destroy]
  before_action :set_project

  layout 'project'

  # GET /teams
  def manage; end

  def manage_data
    @data = User.joins(:teams).where(teams: { project: @project })
                .select('users.* , teams.id as team_id, teams.team_size as size')
    render json: {
      data: @data.group_by(&:team_id),
      teams: Team.where(project: @project).select(:id, :name, :team_size)
    }, status: :ok
  end

  def save_manage
    JSON.parse(params[:data]).each do |team|
      selected_team_id, members = team
      new_team = Team.find(selected_team_id.to_i)
      members.each do |member|
        next unless member['team_id'] != selected_team_id.to_i

        change_team(member, new_team)
      end
    end
    head :ok
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
    authorize! @team
  end

  # POST /teams
  def create
    @team = Team.new(team_params)
    return invite_fail('Not Found') unless allowed_to?(:manage?, @team)

    if @team.save
      flash[:toast_success] = 'Team was successfully created'
      render js: "window.location = '#{project_path(@team.project)}'"
    else
      team_fail(nil)
    end
  end

  # PATCH/PUT /teams/1
  def update
    return team_fail('Not Found') unless allowed_to?(:manage?, @team)

    if @team.update(team_params)
      flash[:toast_success] = 'Team was successfully saved'
      render js:
        "window.location = '#{manage_project_teams_path(@team.project.id)}'"
    else
      team_fail(nil)
    end
  end

  # DELETE /teams/1
  def destroy
    unassigned = Team.find_by(
      project_id: params[:project_id], name: 'Unassigned'
    )
    unassigned.users << @team.users
    @team.destroy
    head :ok
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = Team.find(params[:id])
    authorize! @team
  end

  def set_project
    @project = Project.find(params[:project_id])
    authorize! @project, to: :manage?
  end

  # Only allow a trusted parameter "white list" through.
  def team_params
    params.require(:team).permit(:team_size, :project_id, :name)
  end

  def team_fail(message)
    message ||= @team.errors.full_messages
    render json: { message: message }, status: :unprocessable_entity
  end

  def change_team(member, new_team)
    user = User.find(member['id'])
    old_team = Team.find(member['team_id'])
    old_team.users.delete(user)
    new_team.users << user
  end
end
