class PagesController < ApplicationController

  layout 'landing_page'
  skip_authorization_check

  def home
    @current_nav_identifier = :home
  end

end
