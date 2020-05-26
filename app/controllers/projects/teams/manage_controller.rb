# frozen_string_literal: true

class Projects::Teams::ManageController < Projects::Teams::BaseController
  before_action :set_project

  def index; end

  def manage_data
    return render_404 unless request.xhr?

    @data = User.teams_data(@project)
    compute = CompatibilityCompute.new(@project.teams,
                                       @project.unassigned_team)

    render json: {
      compatibility: @data.to_h { |u| [u.id, compute.call(u)] },
      data: @data.group_by(&:team_id),
      teams: @project.teams&.select(:id, :name, :team_size)
    }
  end

  def suggest
    return team_fail('Invalid Mode') unless %w[balance cohesion efficient].include?(params[:mode])

    suggestion = Suggest.new(User.teams_data(@project),
                             @project.teams.where.not(name: 'Unassigned'),
                             @project.unassigned_team,
                             params[:mode]).call
    render json: { data: suggestion }
  end

  # save_data
  def create
    data = Oj.load(params[:data])
    teams = @project.teams
    users = @project.users
    data.each do |id, members|
      new_team = teams.find { |x| x.id.to_s == id }
      next if new_team.nil?

      authorize! new_team, to: :manage?

      saving_loop(new_team, members, teams, users)
    end
    render json: { data: data }
  end

  def recompute_data
    return team_fail('Invalid Mode') unless %w[balance cohesion efficient].include?(params[:mode])

    i = Oj.load(params[:data])
    teams = @project.teams.find(i.keys)
    d = recompute_loop(i, teams, params[:mode])

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

  def change_team(member, new_team, old_team)
    authorize! new_team, to: :manage?
    new_team.users << member
    old_team.users.delete(member)
  end

  def recompute_loop(input, teams, mode)
    data = {}
    compute = Recompute.new(teams, teams.find { |x| x.name == 'Unassigned' }, mode)

    input.each do |team_id, members|
      next if members.blank?

      data.merge!(
        compute.call(teams.find { |x| x.id.to_s == team_id }, input).to_h
      )
    end
    data
  end

  def saving_loop(new_team, members, teams, users)
    members.each do |m|
      next unless m['team_id'] != new_team.id

      target = users.find { |x| x.id == m['id'] }
      old_team = teams.find { |x| x.id == m['team_id'] }
      change_team(target, new_team, old_team)
      m['team_id'] = new_team.id
    end
  end
end
