# frozen_string_literal: true

# Class for Project policies
class ProjectPolicy < ApplicationPolicy
  relation_scope do |relation|
    next relation if user.admin?

    relation.where(visibility: 'Public')
  end
end
