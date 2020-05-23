# frozen_string_literal: true

module SuggestHelper
  include TeamHelper

  # Obtain the four tier of members
  def split_users(users)
    data_users = users.joins(:user_skills).where.not(personality_id: nil)
    skills_only_users = users.joins(:user_skills).where(personality_id: nil)
    personality_only_users = users.includes(:user_skills)
                                  .where(user_skills: { user_id: nil })
                                  .where.not(users: { personality_id: nil })
                                  .group('user_skills.id')
    data_less_users = users.includes(:user_skills)
                           .where(user_skills: { user_id: nil },
                                  users: { personality_id: nil })
                           .group('user_skills.id')
    puts(data_less_users)
    [data_users, skills_only_users, personality_only_users, data_less_users]
  end

  # Allocate first user to each team
  # best skilled user is put into each group
  # users are expected to be data filled.
  def allocate_first_users(teams, users, mode = 'balance')
    skill_comp = prepare_skill_comp(users, teams)
    top_mem, conflict = get_top_mem(skill_comp)

    until conflict.blank?
      winner = find_winner(top_mem, skill_comp, conflict)
      skill_comp.each { |id, u| u.delete(conflict) if id != winner }
      top_mem, conflict = get_top_mem(skill_comp)
    end

    [top_mem.map { |k, v| [k, [v]] }.to_h, users - top_mem.values]
  end

  private

  def prepare_skill_comp(users, teams)
    skill_comp = teams.map do |t|
      [t.id.to_s, users.map { |u| [u, teamskill_score(t.skills, u.skills)] }
                       .sort_by { |_, v| -v }.to_h]
    end
    skill_comp.to_h
  end

  def get_top_mem(skill_comp)
    top_mem = skill_comp.collect { |k, v| [k, v.first[0]] }.to_h
    conflicts = top_mem.values.select { |e| top_mem.values.count(e) > 1 }.uniq
    [top_mem, conflicts[0]]
  end

  def find_winner(top_mem, skill_comp, contested_user_id)
    conflict_ids = top_mem.select { |_, v| v == contested_user_id }.to_h
    conflict_teams = skill_comp.select { |k, _| conflict_ids.key?(k) }
    resolve(conflict_teams, contested_user_id)
  end

  # if more than one team has similar top users, resolve by comparing total score
  # skill_comps that are competing are parsed in
  # returns the lowest team with lowest skill score
  def resolve(conflict_teams, contested_user_id)
    selected = { id: 0, score: Float::MAX }
    conflict_teams.each do |team_id, users_scores|
      score = users_scores.values.sum - users_scores[contested_user_id]

      selected = { id: team_id, score: score } if score < selected[:score]
    end
    selected[:id]
  end
end
