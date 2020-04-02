# frozen_string_literal: true

class Users::Settings::BillingsController < Users::Settings::BaseController
  def show
    render 'users/settings/billing'
  end

  def update
    current_user.license.update(plan: params[:plan])
    flash[:toast_success] = 'Billing plan updated'
  rescue ArgumentError
    flash[:toast_error] = 'Invalid argument'
  ensure
    redirect_to settings_billing_path
  end
end
