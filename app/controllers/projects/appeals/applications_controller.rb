# frozen_string_literal: true

class Projects::Appeals::ApplicationsController < Projects::Appeals::BaseController
  before_action :set_application, only: %i[accept destroy]

  def index
    project = Project.find(params[:project_id])
    authorize! project, with: Appeal::ApplicationPolicy

    render json: { applications: Appeal.application.list_in_project(project) }
  end

  def create
    @application = Appeal.new(user: current_user,
                              project_id: params[:project_id],
                              type: 'application')

    authorize! @application, with: Appeal::ApplicationPolicy
    return application_fail unless @application.save

    flash[:toast_success] = 'Application sent'
    render js: 'location.reload();'
  end

  def accept
    @application.project.unassigned_team.users << @application.user

    msg = @application.project.errors.full_messages
    return application_fail(msg) unless msg.blank? && @application.delete

    @application.send_resolve_notification('accept')
    head :ok
  end

  def destroy
    return application_fail unless @application.delete

    @application.send_resolve_notification('decline',
                                           current_user == @application.user)

    # TODO: should return JSON only, otherwise the Table will redirect
    flash[:toast_success] = 'Application deleted'
    render js: 'location.reload();'
  end

  private

  def application_fail(msg = @application.errors.full_messages)
    render json: { message: msg.join(', ') }, status: :unprocessable_entity
  end

  def set_application
    @application = Appeal.application.find(params[:id])
    authorize! @application, with: Appeal::ApplicationPolicy
  end
end
