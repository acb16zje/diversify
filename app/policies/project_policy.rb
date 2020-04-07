# frozen_string_literal: true

# Class for Project policies
class ProjectPolicy < ApplicationPolicy
  alias_rule :update?, :change_status, to: :manage?

  relation_scope do |relation|
    next relation if user&.admin?

    relation.where(visibility: true).or(relation.where(user: user))
  end

  def show?
    record.visibility || record.user_id == user&.id || user&.admin? ||
      user&.in_project?(record)
  end

  def manage?
    record.user_id == user&.id || user&.admin?
  end

  def count?
    user.in_project?(record) || user.admin?
  end

  def data?
    user == record.user || user.admin?
  end
end
