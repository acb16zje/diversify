# frozen_string_literal: true

# Class for Task policies
class TaskPolicy < ApplicationPolicy
  default_rule :manage?

  def manage?
    owner? || user&.admin? || record.project.user == user
  end

  def set_percentage?
    owner? || user&.admin? || record.project.user == user ||
      record.users.include?(user)
  end
end
