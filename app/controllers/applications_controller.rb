# frozen_string_literal: true

# Controller for applications/invites for projects
class ApplicationsController < ApplicationController
  before_action :prepare_accept, only: :accept

  def create
    find_user
    @application = Application.new(application_params)
    return application_fail('Invalid Request') unless valid_request?

    @application.save ? application_success : application_fail
  end

  def destroy
    @application = Application.find_by(application_params)
    @application.destroy ? destroy_success : application_fail
  end

  def accept
    return unless valid_accept?

    @team.users << @user
    if @team.save
      application.destroy
      render json: {}, status: :ok
    else
      project_fail
    end
  end

  private

  def prepare_accept
    @application = Applications.find_by(
      project: params[:project_id], user: params[:user_id], types: 'Application')
    @team = application.project.teams.find_by(name: 'Unassigned')
  end

  def valid_accept?
    @team.present? && @application.present?
  end

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

  def application_success
    if params[:types] == 'Invite'
      render json: {
        message: 'Invite Sent', id: @application.user_id,
        name: @application.user.name
      }, status: :ok
    else
      flash[:toast] = { type: 'success', message: ['Application Sent'] }
      render js: "window.location = '#{project_path(@application.project.id)}'"
    end
  end

  def destroy_success
    if current_user == @application.project.user
      render json: {}, status: :ok
    else
      flash[:toast] = { type: 'success', message: ['Application Deleted'] }
      render js: "window.location = '#{project_path(@application.project.id)}'"
    end
  end

  def application_fail
    render json: { message: @application.errors.full_messages },
           status: :bad_request
  end

  def find_user
    params[:user_id] =
      User.where(name: params[:user_id]).first&.id
  end
end
