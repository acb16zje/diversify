# frozen_string_literal: true

class Appeal::BasePolicy < ApplicationPolicy
  def index?
    # Record is a project
    owner? || user.admin?
  end

  def destroy?
    owner? || project_owner? || user.admin?
  end
end
