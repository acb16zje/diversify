class Users::NotificationsWithDeviseController < ActivityNotification::NotificationsWithDeviseController
  # GET /:target_type/:target_id/notifications
  def index
    super
  end

  # POST /:target_type/:target_id/notifications/open_all
  # def open_all
  #   super
  # end

  # GET /:target_type/:target_id/notifications/:id
  # def show
  #   super
  # end

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
    @index_options     = params.permit(:filter, :filtered_by_type, :filtered_by_group_type, :filtered_by_group_id, :filtered_by_key, :later_than, :earlier_than, :routing_scope, :devise_default_routes, :target_type, :devise_type, :user_id)
                                .to_h.symbolize_keys
                                .merge(limit: limit, reverse: reverse, with_group_members: with_group_members)
  end
end
