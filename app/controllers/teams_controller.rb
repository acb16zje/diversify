# frozen_string_literal: true

class TeamsController < ApplicationController
  before_action :set_team, only: %i[show edit update destroy]

  layout 'project'

  # GET /teams
  def manage
    @project = Project.find(params[:project_id])
    authorize! @project, to: :manage?
    @data = User.joins(:teams).where(teams: { project: @project })
                .select('users.*, teams.id as team_id, teams.team_size as size')
    @data = @data.group_by(&:team_id)
    @teams = Team.where(teams: { project: @project })
  end

  # GET /teams/1
  def show; end

  # GET /teams/new
  def new
    @project = Project.find(params[:project_id])
    authorize! @project, to: :manage?
  end

  # GET /teams/1/edit
  def edit; end

  # POST /teams
  def create
    project = Project.find(params[:team][:project_id])
    authorize! project, to: :manage?

    @team = Team.new(team_params)

    if @team.save
      flash[:toast_success] = 'Team was successfully created'
      render js: "window.location = '#{project_path(project)}'"
    else
      team_fail(nil)
    end
  end

  # PATCH/PUT /teams/1
  def update
    if @team.update(team_params)
      redirect_to @team, notice: 'Team was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /teams/1
  def destroy
    @team.destroy
    redirect_to teams_url, notice: 'Team was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = Team.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def team_params
    params.require(:team).permit(:team_size, :project_id, :name)
  end

  def team_fail(message)
    message ||= @team.errors.full_messages
    render json: { message: message }, status: :unprocessable_entity
  end
end
