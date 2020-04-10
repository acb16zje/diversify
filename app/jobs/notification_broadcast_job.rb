class NotificationBroadcastJob < ApplicationJob
  queue_as :default

  def perform(notification)
    NotificationChannel.broadcast_to(
      notification.user,
      message: render_notification(notification)
    )
  end

  private

  def render_notification(notification)
    ApplicationController.renderer.render(
      partial: "notifications/#{notification.key}",
      locals: { notification: notification }
    )
  end
end
