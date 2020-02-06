# frozen_string_literal: true

# Policy for User controller
class UserPolicy < ApplicationPolicy
  # everyone can see any user profile
  def show?
    true
  end

  def edit?
    user && user.id == record.id
  end

  def update?
    user && user.id == record.id
  end
end
