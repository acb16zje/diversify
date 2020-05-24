# frozen_string_literal: true

class Projects::Teams::ManageController < Projects::Teams::BaseController
  before_action :set_project

  def index; end

  def manage_data
    return render_404 unless request.xhr?

    @data = User.teams_data(@project)
    compute = CompatibilityCompute.new(@project.teams.includes(:team_skills),
                                       @project.unassigned_team)

    render json: {
      compatibility: @data.to_h { |u| [u.id, compute.call(u)] },
      data: @data.group_by(&:team_id),
      teams: @project.teams&.select(:id, :name, :team_size)
    }
  end

  def suggest
    suggestion = Suggest.new(User.teams_data(@project),
                             @project.teams.where.not(name: 'Unassigned'),
                             @project.unassigned_team).call
    render json: { data: suggestion }
  end

  # save_data
  def create
    data = Oj.load(params[:data])
    teams = @project.teams
    data.each do |id, members|
      new_team = teams.find{ |x| x.id.to_s == id }
      members.each do |m|
        next unless m['team_id'] != id.to_i

        change_team(m, new_team)
        m['team_id'] = new_team.id
      end
    end
    render json: { data: data }
  end

  def recompute_data
    d = {}
    i = Oj.load(params[:data])
    teams = @project.teams.find(i.keys)
    compute = Recompute.new(teams, teams.find{ |x| x.name == 'Unassigned' })
    i.each do |selected_team_id, members|
      next if members.blank?

      d.merge!(compute.call(teams.find{ |x| x.id.to_s == selected_team_id }, i).to_h)
    end
    render json: { compatibility: d }
  end

  def remove_user
    user = User.find(params[:user_id])
    @team = user.teams.find_by(project: @project)
    return team_fail('Cannot remove owner') if user == @project.user

    @team.users.delete(user)
    head :ok
  end

  private

  def change_team(member, new_team)
    user = @project.users.where(id: member['id']).first
    old_team = user.teams.find_by(project: @project)
    authorize! new_team, to: :manage?
    old_team.users.delete(user)
    new_team.users << user
  end
end
