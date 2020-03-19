# frozen_string_literal: true

# Class for Project policies
class ProjectPolicy < ApplicationPolicy
  alias_rule :update?, :complete?, :uncomplete?, :open_application?,
             :close_application, to: :manage?

  relation_scope do |relation|
    next relation if user&.admin?

    relation.where(visibility: true).or(relation.where(user: user))
  end

  def show?
    record.visibility || owner? || user&.admin?
  end

  def manage?
    record.user_id == user&.id || user&.admin?
  end
end
