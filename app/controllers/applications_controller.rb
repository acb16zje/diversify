# frozen_string_literal: true

# Controller for applications/invites for projects
class ApplicationsController < ApplicationController
  def create
    puts(params)
    find_user
    @application = Application.new(application_params)
    return application_fail('Invalid Request') unless valid_request?

    if @application.save
      application_success('Invite Sent')
    else
      application_fail(@application.errors.full_messages)
    end
  end

  def destroy
    application = Application.where(user_id: params[:id]).first
    if application.destroy
      render json: {}, status: :ok
    end
  end

  private

  def application_params
    params.permit(:user_id, :project_id, :types)
  end

  def valid_request?
    ((params[:types] == 'Invite' &&
      current_user == @application.project&.user) ||
      (params[:types] == 'Application' &&
      @application.project&.visibility?)) && @application&.user
  end

  def application_success(message)
    render json: {
      message: message, id: @application.user_id, name: @application.user.name
    }, status: :ok
  end

  def application_fail(message)
    render json: { message: message }, status: :bad_request
  end

  def find_user
    params[:user_id] =
      User.where(name: params[:user_id]).first&.id
  end
end
