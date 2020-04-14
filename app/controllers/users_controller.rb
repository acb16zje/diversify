# frozen_string_literal: true

# Controller for users
class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: :show

  layout 'user'

  def show
    @user = User.find(params[:id])
  end
end
