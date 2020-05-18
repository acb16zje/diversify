# frozen_string_literal: true

# Base class for application policies
class ApplicationPolicy < ActionPolicy::Base
  authorize :user, allow_nil: true

  def owner?
    record.user_id == user&.id
  end
end
