# frozen_string_literal: true

# Class for Task policies
class TaskPolicy < ApplicationPolicy
  scope_matcher :user, User

  default_rule :manage?

  relation_scope(:assigned) do |scope|
    ids = scope.left_outer_joins(:task_users).where(task_users: { user_id: user&.id }).pluck('task_users.task_id').uniq
    scope.where(id: ids)
  end

  relation_scope(:unassigned) do |scope|
    scope.left_outer_joins(:task_users).having('count(task_users) = 0')
  end

  relation_scope(:active) do |scope|
    scope.having('percentage != 100')
  end

  relation_scope(:completed) do |scope|
    scope.having('percentage = 100')
  end

  def manage?
    owner? || user&.admin? || project_owner?
  end

  def set_percentage?
    manage? || record.users.include?(user)
  end

  def assign_self?
    project_owner? || record.project.users.include?(user)
  end
end
