# frozen_string_literal: true

class Notification < ApplicationRecord
  after_create_commit { NotificationBroadcastJob.perform_later self }

  belongs_to :user
  belongs_to :notifiable, polymorphic: true
  belongs_to :notifier, polymorphic: true

  def unopened?
    opened_at.nil?
  end
end
