# frozen_string_literal: true

# Class for Notification policies
class NotificationPolicy < ApplicationPolicy
  default_rule :manage?

  def manage?
    record.user_id == user&.id
  end
end
