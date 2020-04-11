# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true
  belongs_to :notifier, polymorphic: true

  def unopened?
    opened_at.nil?
  end
end
