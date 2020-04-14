# frozen_string_literal: true

# Policy for Invites controller
class InvitePolicy < ApplicationPolicy
  def create?
    record&.user.present? && (valid_invite? || valid_application?)
  end

  def accept?
    record.managed?(user) || (owner? && record.invite?)
  end

  def destroy?
    record.project.user == user || user&.admin? || owner?
  end

  private

  def valid_invite?
    record.invite? &&
      (user == record.project&.user || user.admin?) && !owner?
  end

  def valid_application?
    record.application? && record.project&.applicable? && owner?
  end
end
