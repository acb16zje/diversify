# frozen_string_literal: true

class ProjectObjectBlueprint < Blueprinter::Base
  field :name

  view :notifier do
    field(:link) { |object| "/projects/#{object.project.id}" }
  end
end
