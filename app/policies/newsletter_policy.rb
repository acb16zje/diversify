# frozen_string_literal: true

# Policy for Newsletter controller
class NewsletterPolicy < ApplicationPolicy
  default_rule :manage?

  alias_rule :index?, :create?, :new?, to: :manage?
  def manage?
    user.admin?
  end
end
