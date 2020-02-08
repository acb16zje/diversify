# frozen_string_literal: true

# Helper for showing avatar images
module AvatarHelper
  def user_avatar(user)
    if user.avatar.attached?
      user.avatar.variant(resize: '100x100!')
    else
      gravatar_image_url(user.email, size: 100, default: :retro)
    end
  end
end
