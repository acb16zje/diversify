# frozen_string_literal: true

# Class for User policies
class UserPolicy < ApplicationPolicy
  relation_scope(:assignee) do |scope, team_id: nil, project: nil|
    next scope.map { |s| [s.name, s.id] } if user&.admin? || project.user_id == user&.id

    scope.includes(:teams).where(teams: { id: team_id }).map { |s| [s.name, s.id] }
  end
end
