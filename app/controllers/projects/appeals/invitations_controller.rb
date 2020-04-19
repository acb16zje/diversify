# frozen_string_literal: true

class Projects::Appeals::InvitationsController < Projects::Appeals::BaseController
  before_action :set_invitation, only: %i[accept destroy]

  def index
    project = Project.find(params[:project_id])
    authorize! project, with: Appeal::InvitationPolicy

    render json: { invitations: Appeal.invitation.list_in_project(project) }
  end

  def create
    @invitation = Appeal.new(user: User.find_by(email: params[:email]),
                             project_id: params[:project_id],
                             type: 'invitation')

    authorize! @invitation, with: Appeal::InvitationPolicy
    return invitation_fail unless @invitation.save

    render json: { invitation: @invitation }
  end

  def accept
    @invitation.project.unassigned_team.users << @invitation.user

    msg = @invitation.project.errors.full_messages
    return invitation_fail(msg) unless msg.blank? && @invitation.delete

    @invitation.send_resolve_notification('accept')
    render js: 'location.reload();'
  end

  def destroy
    return invitation_fail unless @invitation.delete

    @invitation.send_resolve_notification('decline',
                                          current_user == @invitation.user)

    # TODO: should return JSON only, otherwise the Table will redirect
    flash[:toast_success] = 'Invitation deleted'
    render js: 'location.reload();'
  end

  private

  def invitation_fail(msg = @invitation.errors.full_messages)
    render json: { message: msg.join(', ') }, status: :unprocessable_entity
  end

  def set_invitation
    @invitation = Appeal.invitation.find(params[:id])
    authorize! @invitation, with: Appeal::InvitationPolicy
  end
end
