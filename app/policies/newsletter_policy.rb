# frozen_string_literal: true

# Policy for Newsletter controller
class NewsletterPolicy < ApplicationPolicy
  def manage?
    user.admin?
  end

  def index?
    user.admin?
  end

  def new?
    user.admin?
  end

  def create?
    user.admin?
  end

  def subscribers?
    user.admin?
  end
end
