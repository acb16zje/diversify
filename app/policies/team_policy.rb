# frozen_string_literal: true

# Class for Team policies
class TeamPolicy < ApplicationPolicy
  alias_rule :edit?, :update?, :show?, to: :access_team?
  default_rule :manage?

  def access_team?
    record.name != 'Unassigned' && (user&.admin? || record.project.user == user)
  end

  def manage?
    user&.admin? || record.project.user == user
  end
end
