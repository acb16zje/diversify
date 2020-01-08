# frozen_string_literal: true

# Decorate for NewsletterSubscription
class NewsletterDecorator < Draper::Decorator
  delegate_all

  def created_at
    l object.created_at, format: :compact_12
  end
end
