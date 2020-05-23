# frozen_string_literal: true

# Class for Team policies
class TeamPolicy < ApplicationPolicy
  alias_rule :edit?, :update?, to: :access_team?
  default_rule :manage?

  def show?
    (record.project.visibility? || user.in_project?(record.project))
  end

  def access_team?
    record.name != 'Unassigned' && manage?
  end

  def manage?
    user&.admin? || project_owner?
  end
end
