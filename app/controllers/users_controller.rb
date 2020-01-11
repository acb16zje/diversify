class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    respond_to :js
    before_action :authenticate_user!
    authorize_resource

    def show
    end

private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      user = User.find(params[:id])
    end
end