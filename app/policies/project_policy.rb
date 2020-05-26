# frozen_string_literal: true

# Class for Project policies
class ProjectPolicy < ApplicationPolicy
  alias_rule :update?, to: :manage?

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

  relation_scope(:profile_owned) do |scope, profile_owner: nil|
    data = scope.joins(teams: :collaborations).where(user: profile_owner).distinct
    next data if user&.admin || user&.id == profile_owner.id

    data.where("visibility = 't' OR collaborations.user_id = ?", user&.id)
  end

  relation_scope(:profile_joined) do |scope, profile_owner: nil|
    data = scope.joins(teams: :collaborations)
                .where(id: profile_owner.teams.pluck(:project_id))
                .where.not(user: profile_owner).distinct

    next data if user&.admin || user&.id == profile_owner.id

    data.where("visibility = 't' OR collaborations.user_id = ?", user&.id)
  end

  def show?
    record.visibility || manage? || user&.in_project?(record) ||
      record.appeals.invitation.where(user: user).exists?
  end

  def manage?
    (owner? || user&.admin?) && !record.completed?
  end

  def change_status?
    owner? || user&.admin?
  end

  def count?
    user&.in_project?(record) || user&.admin?
  end

  def change_visibility?
    user&.admin? || (!user.license.free? && (owner? || record.new_record?))
  end

  def create_task?
    manage? || (!record.unassigned_team.users.include?(user) &&
      record.teams.any? { |team| team.users.include?(user) })
  end
end
