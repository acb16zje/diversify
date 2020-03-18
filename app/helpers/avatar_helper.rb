# frozen_string_literal: true

# Helper for showing avatar images
module AvatarHelper
  include GravatarImageTag

  def user_avatar(user)
    return user.avatar.variant(resize: '100x100!') if user.avatar.attached?

    gravatar_image_url(user.email, size: 100, default: :retro, secure: true)
  end

  def project_avatar(project)
    if project.avatar.attached?
      project.avatar.variant(resize: '100x100!')
    else
      "http://via.placeholder.com/128x128/ab28f4'/FFFFFF?text="\
        "#{project.name[0]}"
    end
  end
end
