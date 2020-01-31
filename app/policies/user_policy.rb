# frozen_string_literal: true

# Policy for User model
class UserPolicy < ApplicationPolicy
  # everyone can see any user profile
  def show?
    true
  end

  def edit?
    user.id == record.id
  end
end
