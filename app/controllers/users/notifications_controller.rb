# frozen_string_literal: true

# Modified controller for ActivityNotification
class Users::NotificationsController < ActivityNotification::NotificationsController

  layout 'notifications'

  # GET /:target_type/:target_id/notifications
  def index
    return render_404 unless params[:user_id].to_i == current_user.id

    super
    @pagy, @records =
      pagy(ActivityNotification::Notification.where(target_id: current_user))
  end

  # POST /:target_type/:target_id/notifications/open_all
  def open_all
    return render_404 unless @target == current_user

    @target.open_all_notifications(params)
    flash[:toast_success] = 'Opened all Notifications'
    render js: "window.location = '#{user_notifications_path(current_user)}'"
  end

  # GET /:target_type/:target_id/notifications/:id
  def show
    authorize! @notification, with: NotificationPolicy
    super
  end

  # DELETE /:target_type/:target_id/notifications/:id
  # def destroy
  #   super
  # end

  # PUT /:target_type/:target_id/notifications/:id/open
  # def open
  #   super
  # end

  # GET /:target_type/:target_id/notifications/:id/move
  # def move
  #   super
  # end

  protected

  def set_index_options
    limit              = params[:limit].to_i > 0 ? params[:limit].to_i : nil
    reverse            = params[:reverse].present? ?
                          params[:reverse].to_s.to_boolean(false) : nil
    with_group_members = params[:with_group_members].present? || params[:without_grouping].present? ?
                            params[:with_group_members].to_s.to_boolean(false) || params[:without_grouping].to_s.to_boolean(false) : nil
    @index_options     = params.permit(:page, :filter, :filtered_by_type, :filtered_by_group_type, :filtered_by_group_id, :filtered_by_key, :later_than, :earlier_than, :routing_scope, :devise_default_routes, :target_type, :user_id)
                                .to_h.symbolize_keys
                                .merge(limit: limit, reverse: reverse, with_group_members: with_group_members)
  end

  private

  def render_404
    respond_to do |format|
      format.html { render 'errors/error_404', status: :not_found }
      # Prevent the Rails CSRF protector from thinking a missing .js file is a JavaScript file
      format.js { render json: '', status: :not_found }
      format.any { head :not_found }
    end
  end

end
