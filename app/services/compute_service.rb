# frozen_string_literal: true

class ComputeService < ApplicationService
  def best_team?(target, teams, u_list = nil)
    user = u_list.blank? ? target : User.find(target['id'])
    return '' if user.empty_compatibility_data?

    results = compare_team(user, teams, u_list)

    best = results.max_by { |x| x[1] }
    best.blank? || best[1] <= 1.0 ? '' : "(#{best[1].round(2)}) Team #{best[0]}"
  end

  def compare_team(target, teams, u_list = nil)
    results = {}
    teams.each do |team|
      users = u_list.blank? ? team.users : User.find(u_list[team.id.to_s].pluck('id'))
      next if team.name == 'Unassigned' || users.size == team.team_size

      results[team.name] = team_compatibility(target, team, users)
    end
    results
  end

  def team_compatibility(target, team, users)
    user = target.is_a?(Hash) ? User.find(target['id']) : target

    1.0 * team_personality_score(user, users) *
      teamskill_score(team.skills, user.skills)
  end

  def teamskill_score(t_skill, u_skill)
    return 1.0 unless t_skill.present? && u_skill.present?

    1.0 + ((t_skill.size - (t_skill - u_skill).size) / (t_skill.size * 10.0))
  end

  def team_personality_score(target, users)
    return 1.0 if target.personality.blank?

    user_score = 0
    counter = 0
    users.each do |usr|
      next if usr.personality.blank? || target == usr

      user_score += target.compatible_with?(usr)
      counter += 1.0
    end
    counter.zero? ? 1.0 : 1.0 + (user_score / (counter * 10.0))
  end
end
