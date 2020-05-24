# frozen_string_literal: true

class Projects::Teams::TeamsController < Projects::Teams::BaseController
  before_action :set_team, only: %i[edit show update destroy]
  before_action :set_project, except: %i[show]
  before_action :set_skills, only: %i[new edit]
  skip_before_action :authenticate_user!, only: %i[show]

  # GET /teams/new
  def new; end

  # GET /teams/1/edit
  def edit; end

  def show
    extend AvatarHelper

    return render_404 unless request.xhr?

    render json: { member: @team.users, skill: @team.skills&.select(:id, :name),
                   team: @team, images: get_avatars(@team.users.pluck('id')) }
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

  private

  def create_params
    params.require(:team).except(:skill_ids)
          .permit(:team_size, :project_id, :name)
  end

  def edit_params
    params.require(:team).permit(:team_size, :name, skill_ids: [])
  end
end
