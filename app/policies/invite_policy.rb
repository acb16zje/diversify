# frozen_string_literal: true

# Policy for Invites controller
class InvitePolicy < ApplicationPolicy

  def create?
    record&.user.present? && (valid_invite? || valid_application?)
  end

  def accept?
    record.managed?(user) || (record.user == user && record.invite?)
  end

  def destroy?
    record.project.user_id == user&.id ||
      user&.admin? || record.user_id == user&.id
  end

  private

  def valid_invite?
    record.invite? &&
      (user == record.project&.user || user.admin?) &&
      user != record.user
  end

  def valid_application?
    record.application? && record.project&.applicable? &&
      user == record.user
  end
end
