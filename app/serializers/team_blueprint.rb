# frozen_string_literal: true

class TeamBlueprint < Blueprinter::Base
  include Rails.application.routes.url_helpers

  field :name

  view :notifiable do
    field :icon do |team|
      "<div class='project-avatar'>#{icon(team.project)}</div>"
    end
  end

  view :notifier do
    field :link do |team|
      "/projects/#{team.project.id}"
    end
  end

  # rubocop:disable Layout/LineLength
  def self.icon(project)
    if project.avatar.attached?
      "<figure class='image'>"\
        "<img src=#{Rails.application.routes.url_helpers.rails_representation_path(project.avatar.variant(resize: '100x100!'))}>"\
      '</figure>'
    else
      extend ActionView::Context, ActionView::Helpers::TagHelper, AvatarHelper
      extend ActionView::Helpers::AssetTagHelper
      project_icon(project)
    end
  end
  # rubocop:enable Layout/LineLength
end
