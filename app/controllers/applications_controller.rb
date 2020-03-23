#frozen_string_literal: true

class ApplicationsController < ApplicationController

  def create
    application = Application.new(application_params)
    application.project = Project.where(id: application.project_id).first
    application.user = User.where(id: application.user_id).first
    return render json: { message: 'Invalid Request' },
                          status: :bad_request unless application.project&.visibility?

    if application.save
      render json: { message: 'Invite Sent' }, status: :ok
    else
      render json: { message: application.errors.full_messages }, status: :bad_request
    end
  end

  private

  def application_params
    params.require(:application).permit(:user_id, :project_id, :application_type)
  end
end