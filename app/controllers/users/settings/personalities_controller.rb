# frozen_string_literal: true

class Users::Settings::PersonalitiesController < Users::Settings::BaseController
  def show
    render 'users/settings/personalities'
  end

end