# frozen_string_literal: true

# Policy for Newsletter controller
class NewsletterPolicy < ApplicationPolicy
  def manage?
    user.admin?
  end

  def index?
    user.admin?
  end

end
