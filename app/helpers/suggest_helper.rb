# frozen_string_literal: true

module SuggestHelper
  include TeamHelper

  # def suggest(teams, users, mode='balance')
  #   skill_comp = teams.map do |t|
  #     [t.id,
  #      users.map { |u| [u.id, teamskill_score(t.skills, u.skills)] }
  #           .to_h.sort_by { |_, v| -v }]
  #   end
  #   skills_comp.to_h

  # end

  # def allocate_first_users(teams, users, mode='balance')
end
