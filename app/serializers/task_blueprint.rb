# frozen_string_literal: true

class TaskBlueprint < Blueprinter::Base
  extend AvatarHelper

  fields :id, :description, :name, :percentage, :priority

  field :owner_id do |task|
    task.user.id
  end

  field :owner_name do |task|
    task.user.name
  end

  field :skills do |task|
    task.skills.pluck(:name)
  end

  association :users, name: :assignees, view: :assignee, blueprint: UserBlueprint
end
