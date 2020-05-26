# frozen_string_literal: true

class SendNotificationJob < ApplicationJob
  queue_as :default

  def perform(users, params)
    users.each do |user|
      Notification.create(
        user: user,
        key: params[:key],
        notifiable: params[:notifiable],
        notifier: params[:notifier]
      )
    end
  end
end
