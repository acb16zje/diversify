# frozen_string_literal: true

class Recompute < ComputeService
  def initialize(teams, unassigned)
    @teams = teams
    @unassigned = unassigned
  end

  def call(target_team, u_list)
    members = u_list[target_team.id.to_s]

    if @unassigned == target_team
      members.map { |u| [u['id'], best_team?(u, @teams, u_list)] }
    else
      users = User.find(members.pluck('id'))
      return if target_team.users == users

      users.map do |u|
        [u.id, team_compatibility(u, target_team, users).round(2).to_s]
      end
    end
  end
end
