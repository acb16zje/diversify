# frozen_string_literal: true

class Suggest < ComputeService
  def initialize(users, teams, unassigned, mode = 'balance')
    @users = split_users(users)
    @teams = teams
    @unassigned = unassigned
    @mode = mode
    @weightage = WEIGHTAGE[mode.to_sym]
  end

  def call
    suggestion, leftover = allocate_first_users
    puts(suggestion)
    is_coh = @mode == 'cohesion'
    [leftover, @users[is_coh ? 2 : 1], @users[is_coh ? 1 : 2]].each do |data|
      suggestion = match(data, suggestion)
    end

    leftover = @users.flatten - suggestion.values.flatten
    suggestion[@unassigned.id] = leftover
    suggestion
  end

  private

  def split_users(users)
    [users.where.not(user_skills: { user_id: nil })
          .where.not(users: { personality_id: nil }).group('user_skills.id'),
     users.where.not(user_skills: { user_id: nil })
          .where(personality_id: nil).group('user_skills.id'),
     users.where(user_skills: { user_id: nil })
          .where.not(users: { personality_id: nil })
          .group('user_skills.id'),
     users.where(user_skills: { user_id: nil }, users: { personality_id: nil })
          .group('user_skills.id')]
  end

  def allocate_first_users
    return [@teams.map { |t| [t.id, []] }.to_h, []] if @users[0].blank?

    top_mem = first_users_loop

    [top_mem.map { |k, v| v.nil? ? [k, []] : [k, [v]] }.to_h, @users[0] - top_mem.values]
  end

  def first_users_loop
    skill_comp = prepare_skill_comp
    top_mem, conflict = get_top_mem(skill_comp)

    until conflict.blank?
      winner = find_winner(top_mem, skill_comp, conflict)
      skill_comp.each { |id, u| u.delete(conflict) if id != winner }
      top_mem, conflict = get_top_mem(skill_comp)
    end
    top_mem
  end

  def prepare_skill_comp
    skill_comp = @teams.map do |t|
      t_s = t.team_skills.pluck(:skill_id)
      data = prepare_skill_comp_loop(t_s)
      [t.id.to_s, data.sort_by { |_, v| -v }.to_h]
    end
    skill_comp.to_h
  end

  def prepare_skill_comp_loop(t_s)
    @users[0].map do |u|
      [u, teamskill_score(t_s, u.user_skills.pluck(:skill_id)) * @weightage[1]]
    end
  end

  def get_top_mem(skill_comp)
    top_mem = skill_comp.collect { |k, v| [k, v.first&.[](0)] }.to_h
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

  def match(data, suggestion)
    data.each do |u|
      compare_team(u, @teams, suggestion, @mode == 'cohesion', @weightage).sort_by { |_, v| -v }.each do |k, v|
        team = @teams.where(name: k).first
        target = suggestion[team.id.to_s]
        next if target.size == team.team_size || v <= 1.0

        target.push(u)
        break
      end
    end
    suggestion
  end
end
