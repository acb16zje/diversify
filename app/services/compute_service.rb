# frozen_string_literal: true

class ComputeService
  WEIGHTAGE = {
    "balance": [1.0, 1.0],
    "cohesion": [1.5, 0.5],
    "efficient": [0.5, 1.5]
  }.freeze

  def best_team?(target, teams, u_list = nil)
    user = u_list.blank? ? target : User.find(target['id'])
    return '' if user.empty_compatibility_data?

    results = compare_team(user, teams, u_list)

    best = results.max_by { |x| x[1] }
    best.blank? || best[1] <= 1.0 ? '' : "(#{best[1].round(2)}) Team #{best[0]}"
  end

  def compare_team(target, teams, u_list = nil, ignore_empty = false, weightage = [1.0, 1.0])
    results = {}
    teams.each do |team|
      next if valid_team_compare(team, u_list, ignore_empty)

      users = prepare_team_compare(team, u_list)

      results[team.name] = team_compatibility(target, team, users, weightage) if users.size < team.team_size
    end
    results
  end

  def team_compatibility(target, team, users, weightage = [1.0, 1.0])
    1.0 * team_personality_score(target, users, weightage[0]) *
      teamskill_score(team.team_skills.pluck(:skill_id),
                      target.user_skills.pluck(:skill_id), weightage[1])
  end

  def teamskill_score(t_skill, u_skill, weightage = 1.0)
    return 1.0 if t_skill.empty? || u_skill.empty?

    1.0 + (weightage *
      (t_skill.size - (t_skill - u_skill).size) / (t_skill.size * 5.0))
  end

  def team_personality_score(target, users, weightage = 1.0)
    return 1.0 if target.personality_id.blank?

    user_score = 0
    counter = 0
    users.each do |usr|
      next if usr.personality_id.blank? || target == usr

      user_score += target.compatible_with?(usr)
      counter += 1.0
    end
    counter.zero? ? 1.0 : 1.0 + (weightage * (user_score / (counter * 10.0)))
  end

  private

  def valid_team_compare(team, u_list, ignore_empty)
    return true if team.name == 'Unassigned'

    return false if u_list.nil?

    !u_list.key?(team.id.to_s) || (ignore_empty && u_list[team.id.to_s].empty?)
  end

  def prepare_team_compare(team, list)
    return team.users if list.blank?

    list[team.id.to_s].empty? ? [] : User.find(list[team.id.to_s].pluck('id'))
  end
end
