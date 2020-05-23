# frozen_string_literal: true

class Projects::Teams::ManageController < Projects::Teams::BaseController
  before_action :set_project

  include TeamHelper

  def index; end

  def manage_data
    return render_404 unless request.xhr?

    @data = User.teams_data(@project)

    render json: {
      compability: @data.map { |u|
        [u.id, compability(u, @project.teams, @project.unassigned_team)]
      }.to_h, data: @data.group_by(&:team_id),
      teams: @project.teams&.select(:id, :name, :team_size)
    }
  end

  # save_data
  def create
    Oj.load(params[:data]).each do |id, members|
      new_team = Team.find(id.to_i)
      members.each { |m| change_team(m, new_team) if m['team_id'] != id.to_i }
    end
    head :ok
  end

  def recompute_data
    d = {}
    i = Oj.load(params[:data])
    i.each do |selected_team_id, members|
      team = @project.teams.find_by(id: selected_team_id)
      next if members.blank? || team.blank?

      d.merge!(recompute(@project.teams, @project.unassigned_team, team, i).to_h)
    end
    render json: { compability: d }
  end

  def remove_user
    user = User.find(params[:user_id])
    @team = user.teams.find_by(project: @project)
    return team_fail('Cannot remove owner') if user == @project.user

    @team.users.delete(user)
    head :ok
  end
end
