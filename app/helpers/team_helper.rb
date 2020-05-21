# frozen_string_literal: true

# Helper for team allocation
module TeamHelper
  def compability(target, teams, unassigned_id)
    team = teams.where(id: target.team_id).first
    if unassigned_id == target.team_id
      best_team?(target, teams)
    else
      team_compability(target, team).round(2).to_s
    end
  end

  # this function currently runs with the assumptions that there are users in the project
  # called on compute function for unassigned users
  # does not have to consider team size, just user to team
  def best_team?(target, teams)
    return '' if target.personality.blank? && target.skills.blank?

    results = {}
    teams.each do |team|
      next if team.name == 'Unassigned' || team.users.size == team.team_size

      results[team.name] = team_compability(target, team)
    end
    puts(results)
    best = results.max_by{ |x| x[1] }
    best.blank? || best[1] <= 1.0 ?  '' : "Team #{best[0]}"
  end

  def team_compability(target, team)
    1.0 * team_personality_score(target, team.users) *
      team_skills_score(team.skills, target.skills)
  end

  def member_compability(target, user)
    target.compatible_with?(user)
  end

  private

  def team_skills_score(t_skills, u_skills)
    return 1.0 unless t_skills.present? && u_skills.present?

    1.0 + ((t_skills.size - (t_skills - u_skills).size) / (t_skills.size * 10.0))
  end

  def team_personality_score(target, users)
    return 1.0 if target.personality.blank?

    user_score = 0
    counter = 0
    users.each do |usr|
      next if usr.personality.blank? || target == usr

      user_score += member_compability(target, usr)
      counter += 1.0
    end
    counter.zero? ? 1.0 : 1.0 + (user_score / (counter * 10.0))
  end
end
