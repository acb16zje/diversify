# frozen_string_literal: true

class NotificationBlueprint < Blueprinter::Base
  extend ActionView::Helpers::DateHelper

  fields :id, :key, :read

  field :time_ago do |notification|
    "#{time_ago_in_words(notification.created_at)} ago"
  end

  association :notifiable, blueprint: lambda { |notifiable|
    case notifiable.class.name
    when 'User'
      UserBlueprint
    when 'Project'
      ProjectBlueprint
    end
  }, view: :notifiable

  association :notifier, blueprint: lambda { |notifier|
    case notifier.class.name
    when 'Project'
      ProjectBlueprint
    end
  }, view: :notifier
end
