# frozen_string_literal: true

# Decorate for NewsletterSubscription
class NewsletterSubscriptionDecorator < Draper::Decorator
  delegate_all

  def created_at
    l object.created_at, format: :date
  end
end
