# frozen_string_literal: true

# Class for Project policies
class ProjectPolicy < ApplicationPolicy
  relation_scope do |relation|
    next relation if user&.admin?

    relation.where(visibility: true).or(relation.where(user: user))
  end

  def show?
    record.visibility || owner? || user&.admin?
  end
end
