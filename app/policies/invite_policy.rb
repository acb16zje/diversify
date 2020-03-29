# frozen_string_literal: true

# Policy for Invites controller
class InvitePolicy < ApplicationPolicy
  alias_rule :destroy?, :accept?, to: :manage?

  def manage?
    record.project.user_id == user&.id || user&.admin? ||
      record.user_id == user&.id
  end
end
