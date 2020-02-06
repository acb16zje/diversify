# frozen_string_literal: true

# Policy for User controller
class UserPolicy < ApplicationPolicy
  # everyone can see any user profile
  def show?
    true
  end

  def manage?
    user && user.id == record.id
  end
end
