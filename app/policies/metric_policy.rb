# frozen_string_literal: true

# Policy for Metrics controller
class MetricPolicy < ApplicationPolicy
  alias_rule :index?, to: :manage?

  def manage?
    user.admin?
  end
end
