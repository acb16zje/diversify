# frozen_string_literal: true

class Appeal::InvitationPolicy < Appeal::BasePolicy
  def create?
    project_owner? || user.admin?
  end

  def accept?
    owner? && !project_owner? || user.admin?
  end
end
