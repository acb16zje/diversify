# frozen_string_literal: true

class UserBlueprint < Blueprinter::Base
  field :name

  # rubocop:disable Layout/LineLength
  view :notifiable do
    field :icon do |user|
      extend AvatarHelper

      icon = if user.avatar.attached?
               Rails.application.routes.url_helpers.rails_representation_path(user_avatar(user))
             else
               user_avatar(user)
             end

      "<figure class='image is-48x48 user-avatar-container mr-4'>"\
        "<img src=#{icon}>"\
      '</figure>'
    end
  end
  # rubocop:enable Layout/LineLength
end
