# frozen_string_literal: true

# Controller for users
class UsersController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_user, only: %i[show timeline]
  layout 'user'

  def show
    render_projects(params[:joined].present? ? :profile_joined : :profile_owned)
    prepare_skills
    prepare_counts
  end

  def timeline
    return render_404 unless request.xhr?

    m = find_next_activity(params[:month].to_i)
    if m.present?
      render_timeline(m)
    else
      render json: { header: 'End of Timeline' }
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def find_next_activity(mth)
    time = DateTime.current.beginning_of_month << mth
    data = Activity.where('user_id = ? AND created_at <= ?', @user.id, time)
    return unless data.exists?

    data.order('created_at DESC').first.created_at.to_datetime
  end

  def render_timeline(mth)
    tasks, events = authorized_scope(Activity.where(user: @user).from_month(mth))
    html = view_to_html_string('users/_timeline', events: events, tasks: tasks,
                                                  header: mth.strftime('%B %Y'))
    render json: { html: html, m: ((Time.current - mth) / 1.month).floor }
  end

  def render_projects(policy_scope)
    @pagy, projects = pagy(authorized_scope(
                             Project.search(params),
                             as: policy_scope,
                             scope_options: { target: @user }
                           ))
    @html = view_to_html_string('projects/_projects', projects: projects)

    respond_to do |format|
      format.html
      format.json { render json: { html: @html, total: @pagy.count } }
    end
  end

  def prepare_skills
    @skills = UserSkill.joins(skill: :category).where(user_id: @user.id)
                       .select('user_skills.created_at')
                       .select('skills.name AS name')
                       .select('categories.name AS category_name')
    @chart = @user.skills.joins(:category)
                  .select('categories.name')
                  .group('categories.name').count
  end

  def prepare_counts
    joined_ids = if @user.teams.present?
                   '(' + @user.teams.pluck(:project_id).join(',') + ')'
                 else '(0)' end

    @counts = @user.projects.pluck(
      Arel.sql(
        "(SELECT COUNT(1) FROM projects WHERE id IN #{joined_ids} AND NOT user_id = #{@user.id}),"\
        'COUNT(1),'\
        "(SELECT COUNT(1) FROM projects WHERE id IN #{joined_ids} AND status = 'completed')")
    ).first
  end
end
