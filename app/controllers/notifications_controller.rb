# frozen_string_literal: true

# Controller for notifications
class NotificationsController < ApplicationController
  before_action :set_notification, only: %i[destroy read unread]

  def index
    return render_404 unless request.xhr?

    _, notifications = pagy(current_user.notifications.load_index, items: 5)

    render json: NotificationBlueprint.render(notifications)
  end

  def destroy
    @notification.delete ? head(:ok) : head(:bad_request)
  end

  def read
    @notification.update_columns(read: true) # rubocop:disable Rails/SkipsModelValidations
    head :ok
  end

  def unread
    @notification.update_columns(read: false) # rubocop:disable Rails/SkipsModelValidations
    head :ok
  end

  def read_all
    current_user.notifications.unread.update_all(read: true) # rubocop:disable Rails/SkipsModelValidations
    head :ok
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
    authorize! @notification, with: NotificationPolicy
  end
end
