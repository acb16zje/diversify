# frozen_string_literal: true

class ProjectBlueprint < Blueprinter::Base
  extend ActionView::Context
  extend ActionView::Helpers::TagHelper
  extend ActionView::Helpers::AssetTagHelper
  extend AvatarHelper

  field :name

  view :notifiable do
    field :icon do |project|
      "<div class='project-avatar'>#{project_icon(project)}</div>"
    end
  end

  view :notifier do
    field :link do |project|
      "/projects/#{project.id}"
    end
  end
end
