# frozen_string_literal: true

# Modified controller for ActivityNotification
class NotificationsController < ApplicationController
  # before_action :find_notification
  # before_action :authorize_notification, except: %i[index open_all]
  layout 'notifications'

  # GET /:target_type/:target_id/notifications
  def index
    @pagy, @records = pagy(Notification.where(user: current_user))
  end

  # POST /:target_type/:target_id/notifications/open_all
  def open_all
    return render_404 unless @target == current_user

    @target.open_all_notifications(params)
    flash[:toast_success] = 'Opened all Notifications'
    render js: "window.location = '#{user_notifications_path(current_user)}'"
  end

  # GET /:target_type/:target_id/notifications/:id
  # def show
  #   super
  # end

  # DELETE /:target_type/:target_id/notifications/:id
  # def destroy
  #   super
  # end

  # PUT /:target_type/:target_id/notifications/:id/open
  def open
    notification = Notification.find_by(id: params[:id])
    notification.opened_at = DateTime.now
    notification.save(validate: false)
    redirect_to notification.notifier
  end

  # GET /:target_type/:target_id/notifications/:id/move
  # def move
  #   super
  # end

  protected

  # def authorize_notification
  #   authorize! @notification, with: NotificationPolicy
  # end
end
