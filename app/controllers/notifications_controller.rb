# frozen_string_literal: true

# Controller for notifications
class NotificationsController < ApplicationController

  layout 'notifications'

  def index
    @pagy, @records = pagy(Notification.where(user: current_user))
  end

  def open_all
    notifications = Notification.where(user: current_user, opened_at: nil)

    notifications.each do |notification|
      notification.opened_at = DateTime.now
      notification.save
    end

    flash[:toast_success] = 'Opened all Notifications'
    render js: "window.location = '#{notifications_path}'"
  end

  def open
    notification = Notification.find(params[:id])

    authorize! notification
    notification.opened_at = DateTime.now
    notification.save
    redirect_to notification.notifier
  end
end
