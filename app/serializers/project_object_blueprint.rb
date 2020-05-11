# frozen_string_literal: true

class ProjectObjectBlueprint < Blueprinter::Base
  include Rails.application.routes.url_helpers

  field :name

  view :notifier do
    field :link do |object|
      "/projects/#{object.project.id}"
    end
  end
end
