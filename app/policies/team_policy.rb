# frozen_string_literal: true

# Class for Team policies
class TeamPolicy < ApplicationPolicy
  default_rule :manage?

  def edit?
    record.name != 'Unassigned' && (user&.admin? || record.project.owner?)
  end

  def manage?
    user&.admin? || record.project.owner?
  end
end
