# frozen_string_literal: true

class Recompute < ComputeService
  def initialize(teams, unassigned, mode = 'balance')
    @teams = teams
    @unassigned = unassigned
    @weightage = WEIGHTAGE[mode.to_sym]
  end

  def call(target_team, u_list)
    members = u_list[target_team.id.to_s]

    if @unassigned == target_team
      members.map { |u| [u['id'], best_team?(u, @teams, u_list)] }
    else
      users = User.includes(:user_skills).find(members.pluck('id'))

      users.map do |u|
        [u.id, team_compatibility(u, target_team, users, @weightage).round(2).to_s]
      end
    end
  end
end
