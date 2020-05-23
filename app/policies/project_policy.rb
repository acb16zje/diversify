# frozen_string_literal: true

# Class for Project policies
class ProjectPolicy < ApplicationPolicy
  alias_rule :update?, :change_status?, to: :manage?

  relation_scope(:own) do |scope|
    scope.where(user: user)
  end

  relation_scope(:joined) do |scope|
    scope.where(id: user.teams.pluck(:project_id)).where.not(user: user)
  end

  relation_scope(:explore) do |scope|
    next scope if user&.admin

    scope.where(visibility: true).or(scope.where(user: user)).distinct
  end

  relation_scope(:profile_owned) do |scope, target: nil|
    data = scope.joins(teams: :collaborations).where(user: target).distinct
    next data if user&.admin || user == target

    data.where(visibility: true).or(data.where(collaborations: { user_id: user&.id }))
  end

  relation_scope(:profile_joined) do |scope, target: nil|
    data = scope.joins(teams: :collaborations)
                .where(id: target.teams.pluck(:project_id))
                .where.not(user: target).distinct

    next data if user&.admin || user == target

    data.where(visibility: true).or(data.where(collaborations: { user_id: user&.id }))
  end

  def show?
    record.visibility || owner? || user&.admin? || user&.in_project?(record) ||
      record.appeals.where(user: user, type: 'invitation').exists?
  end

  def manage?
    owner? || user&.admin?
  end

  def count?
    user&.in_project?(record) || user&.admin?
  end

  def change_visibility?
    user&.admin? || !user.license.free?
  end

  def create_task?
    manage? || (!record.unassigned_team.users.include?(user) &&
      record.teams.any? { |team| team.users.include?(user) })
  end
end
