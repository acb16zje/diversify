# frozen_string_literal: true

class Projects::Teams::ManageController < Projects::Teams::BaseController
  before_action :set_project

  include TeamHelper
  include SuggestHelper

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

  def suggest
    users = split_users(User.teams_data(@project))
    suggestion, leftover = allocate_first_users(@project.teams.where.not(name: 'Unassigned'), users[0])

    [leftover, users[1], users[2]].each do |data|
      suggestion = match(data, suggestion)
    end

    leftover = users.flatten - suggestion.values.flatten
    suggestion[@project.unassigned_team.id] = leftover
    render json: { data: suggestion }
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

  def match(data, suggestion)
    data.each do |user|
      puts(suggestion)
      results = compare_team(user, @project.teams.where.not(name: 'Unassigned'), suggestion)
      results.sort_by { |_, v| -v }.each do |k, _|
        puts(k)
        team = @project.teams.find_by(name: k)
        next if suggestion[team.id.to_s].size == team.team_size

        suggestion[team.id.to_s].push(user)
        break
      end
      puts("im out")
    end
    suggestion
  end
end
