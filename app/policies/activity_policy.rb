# frozen_string_literal: true

# Class for Activity Policies
class ActivityPolicy < ApplicationPolicy
  relation_scope do |scope|
    task = scope.joins(:project)
                .where("activities.key LIKE '%task%'")
                .select('projects.name AS name, projects.id AS project_id')
                .select('COUNT(projects.id) as count')
                .group('projects.id')

    project = scope.joins(:project)
                   .where("activities.key NOT LIKE '%task%'")
                   .select('activities.id, activities.created_at, key')
                   .select('projects.name AS name, projects.id AS project_id')
                   .order('activities.created_at DESC')

    user = scope.where("activities.key LIKE '%user%'")
                .select('activities.id, activities.created_at, activities.key')

    return task, (project + user)
  end
end
