# frozen_string_literal: true

# Controller for users
class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: :show

  before_action :set_user, only: :show

  layout 'user'

  def show; end

  private

  def set_user
    @user = User.find(params[:id])
    authorize! @user
  end
end
