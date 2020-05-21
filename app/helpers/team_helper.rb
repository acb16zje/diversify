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

  def best_team?(target, teams)
    return '' if target.empty_compability_data?

    results = compare_team(target, teams)

    best = results.max_by{ |x| x[1] }
    best.blank? || best[1] <= 1.0 ? '' : "Team #{best[0]}"
  end

  def compare_team(target, teams)
    results = {}
    teams.each do |team|
      next if team.name == 'Unassigned' || team.users.size == team.team_size

      results[team.name] = team_compability(target, team)
    end
    results
  end

  def team_compability(target, team)
    1.0 * team_personality_score(target, team.users) *
      team_skills_score(team.skills, target.skills)
  end

  def member_compability(target, user)
    target.compatible_with?(user)
  end

  private

  def team_skills_score(t_skill, u_skill)
    return 1.0 unless t_skill.present? && u_skill.present?

    1.0 + ((t_skill.size - (t_skill - u_skill).size) / (t_skill.size * 10.0))
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
