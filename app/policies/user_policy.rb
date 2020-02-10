# frozen_string_literal: true

# Policy for User controller
class UserPolicy < ApplicationPolicy
  # everyone can see any user profile
  def show?
    true
  end
end
