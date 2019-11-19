class PagesController < ApplicationController

  skip_authorization_check

  def home
    @current_nav_identifier = :home
  end

  def newsletter
    ahoy.track "Clicked pricing link", type: params[:type]
  end
end
