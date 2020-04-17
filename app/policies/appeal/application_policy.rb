# frozen_string_literal: true

class Appeal::ApplicationPolicy < Appeal::BasePolicy
  def create?
    record.project.applicable? && !project_owner?
  end

  def accept?
    !owner? && project_owner? || user.admin?
  end
end
