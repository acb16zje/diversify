# frozen_string_literal: true

class UserBlueprint < Blueprinter::Base
  extend AvatarHelper

  field :name

  view :notifiable do
    field :icon do |user|
      "<figure class='image is-48x48 user-avatar-container mr-4'>"\
        "<img src=#{user_avatar(user)}>"\
      '</figure>'
    end
  end

  view :assignee do
    field :id

    field :icon do |user|
      user_avatar(user)
    end
  end
end
