# frozen_string_literal: true

class Projects::TeamsController < ApplicationController
  before_action :set_team, only: %i[edit show update destroy remove_user]
  before_action :set_project, except: %i[show update destroy remove_user]
  before_action :set_skills, only: %i[new edit]

  layout 'project'

  # GET /teams
  def manage; end

  def manage_data
    return render_404 unless request.xhr?

    @data = User.joins(:teams).where(teams: { project: @project })
                .select('users.*, teams.id as team_id')
    render json: {
      data: @data.group_by(&:team_id),
      teams: Team.where(project: @project).select(:id, :name, :team_size)
    }
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
    @project = Project.find(params[:project_id])
  end

  def show
    return render_404 unless request.xhr?

    render json: {
      name: @team.name, skills: @team.skills&.select(:id, :name),
      team_size: @team.team_size, member_count: @team.users.size
    }
  end

  # POST /teams
  def create
    skill_ids = params[:team][:skill_ids]
    @team = Team.new(create_params)
    if @team.save
      @team.skills << Skill.find(skill_ids.drop(1)) if skill_ids.present?
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
    team = Team.find_by(project_id: params[:project_id], name: 'Unassigned')
    team.users << @team.users
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

  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = Team.find(params[:id])
    authorize! @team
  end

  def set_skills
    @skills = Skill.where(category: @project.category)
                   .collect { |s| [s.name, s.id] }
  end

  def set_project
    @project = Project.find(params[:project_id])
    authorize! @project, to: :manage?
  end

  def create_params
    params.require(:team).except(:skill_ids)
          .permit(:team_size, :project_id, :name)
  end

  def edit_params
    params.require(:team).permit(:team_size, :project_id, :name, skill_ids: [])
  end

  def team_success(message)
    flash[:toast_success] = message
    render js:
      "window.location = '#{manage_project_teams_path(@team.project)}'"
  end

  def team_fail(message = @team.errors.full_messages)
    render json: { message: message }, status: :unprocessable_entity
  end

  def change_team(member, new_team)
    user = User.find(member['id'])
    old_team = Team.find(member['team_id'])
    authorize! old_team
    authorize! new_team
    old_team.users.delete(user)
    new_team.users << user
  end
end
