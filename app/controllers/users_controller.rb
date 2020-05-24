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

    month = find_next_activity(params[:month].to_i)
    month.present? ? render_timeline(month) : head(:no_content)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def find_next_activity(month)
    data = @user.activities.where('created_at <= ?',
                                  DateTime.current.beginning_of_month << month)

    data.order('created_at DESC').first.created_at.to_datetime if data.exists?
  end

  def render_timeline(mth)
    tasks, events = authorized_scope(@user.activities.from_month(mth))
    html = view_to_html_string('users/_timeline',
                               events: events,
                               tasks: tasks,
                               header: mth.strftime('%B %Y'))

    render json: { html: html, m: ((Time.current - mth) / 1.month).floor }
  end

  def render_projects(policy_scope)
    pagy, projects = pagy(authorized_scope(
                            Project.search(params),
                            as: policy_scope,
                            scope_options: { target: @user }
                          ))
    html = view_to_html_string('projects/_projects', projects: projects)

    respond_to do |format|
      format.html
      format.json { render json: { html: html, total: pagy.count } }
    end
  end

  def prepare_skills
    @skills = @user.user_skills.joins(skill: :category)
                   .select('user_skills.created_at')
                   .select('skills.name AS name')
                   .select('categories.name AS category_name')
    @chart = @user.skills.joins(:category)
                  .select('categories.name')
                  .group('categories.name').count
  end

  def prepare_counts
    joined_ids = @user.teams.present? ? "(#{@user.teams.pluck(:project_id).join(',')})" : '(0)'

    @counts = @user.projects.pluck(
      Arel.sql(
        "(SELECT COUNT(1) FROM projects WHERE id IN #{joined_ids} AND NOT user_id = #{@user.id}),"\
        'COUNT(1),'\
        "(SELECT COUNT(1) FROM projects WHERE id IN #{joined_ids} AND status = 'completed')"
      )
    ).first
  end
end
