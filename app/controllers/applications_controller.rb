# frozen_string_literal: true

# Controller for applications/invites for projects
class ApplicationsController < ApplicationController
  def create
    find_user
    @application = Application.new(application_params)
    return application_fail('Invalid Request') unless valid_request?

    if @application.save
      if params[:types] == 'Invite'
        application_success('Invite Sent')
      else
        flash[:toast] = { type: 'success', message: ['Application Sent'] }
        render js: "window.location = '#{project_path(@application.project.id)}'"
      end
    else
      application_fail(@application.errors.full_messages)
    end
  end

  def destroy
    puts(params)
    application = Application.where(user_id: params[:id], types: params[:types]).first
    if application.destroy
      if params[:types] == 'Invite'
        render json: {}, status: :ok
      else
        flash[:toast] = { type: 'success', message: ['Application Deleted'] }
        render js: "window.location = '#{project_path(application.project.id)}'"
      end
    else
      render json: { message: application.errors.full_messages },
             error: :bad_request
    end
  end

  private

  def application_params
    params.except(:authenticity_token).permit(:user_id, :project_id, :types)
  end

  def valid_request?
    ((params[:types] == 'Invite' &&
      current_user == @application.project&.user &&
      current_user != @application.user) ||
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
