# frozen_string_literal: true

class SendNotificationJob < ApplicationJob
  queue_as :default

  def perform(params)
    Notification.create(
      user: params[:user],
      key: params[:key],
      notifiable: params[:notifiable],
      notifier: params[:notifier]
    )
  end
end
