# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  # everyone can see any post
  def show?
    true
  end

  def edit?
    # `user` is a performing subject,
    # `record` is a target object (post we want to update)
    user.admin? || (user.id == record.id)
  end
end
