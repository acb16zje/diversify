# frozen_string_literal: true

# Policy for Metrics controller
class AdminPolicy < ApplicationPolicy
  default_rule :manage?
  alias_rule :index?, :create?, :new?, to: :manage?

  def manage?
    user.admin?
  end
end
