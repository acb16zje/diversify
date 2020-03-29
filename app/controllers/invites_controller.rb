# frozen_string_literal: true

# Controller for applications/invites for projects
class InvitesController < ApplicationController
  before_action :prepare_accept, only: :accept

  def create
    find_user
    @invite = Invite.new(invite_params)
    return invite_fail('Invalid Request') unless valid_request?

    @invite.save ? invite_success : invite_fail(nil)
  end

  def destroy
    @invite = Invite.find_by(invite_params)
    puts(@invite)
    authorize! @invite
    @invite.destroy ? destroy_success : invite_fail(nil)
  end

  def accept
    return invite_fail('Invalid Request') unless valid_accept?

    authorize! @invite

    @team.users << @invite.user
    if @team.save
      @invite.destroy
      render json: {}, status: :ok
    else
      invite_fail(nil)
    end
  end

  private

  def prepare_accept
    @invite = Invite.find_by(invite_params)
    @team = @invite.project.teams.find_by(name: 'Unassigned')
  end

  def valid_accept?
    @team.present? && @invite.present?
  end

  def invite_params
    params.except(:id,:_method, :authenticity_token)
          .permit(:user_id, :project_id, :types)
  end

  def valid_request?
    ((params[:types] == 'Invite' &&
      current_user == @invite.project&.user &&
      current_user != @invite.user) ||
      (params[:types] == 'Application' &&
      @invite.project&.visibility?)) && @invite&.user
  end

  def invite_success
    if params[:types] == 'Invite'
      render json: {
        message: 'Invite Sent', id: @invite.user_id,
        name: @invite.user.name
      }, status: :ok
    else
      flash[:toast] = { type: 'success', message: ['Application Sent'] }
      render js: "window.location = '#{project_path(@invite.project.id)}'"
    end
  end

  def destroy_success
    if current_user == @invite.project.user
      render json: {}, status: :ok
    else
      flash[:toast] = { type: 'success', message: ['Application Deleted'] }
      render js: "window.location = '#{project_path(@invite.project.id)}'"
    end
  end

  def invite_fail(message)
    message ||= @application.errors.full_messages
    render json: { message: message },
           status: :bad_request
  end

  def find_user
    params[:user_id] =
      User.where(name: params[:user_id]).first&.id
  end
end
