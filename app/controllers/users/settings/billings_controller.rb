# frozen_string_literal: true

class Users::Settings::BillingsController < Users::Settings::BaseController
  def show
    render 'users/settings/billing'
  end
end
