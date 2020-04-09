# frozen_string_literal: true

# Helper for showing avatar images
module AvatarHelper
  include GravatarImageTag

  def user_avatar(user)
    return user.avatar.variant(resize: '100x100!') if user.avatar.attached?

    gravatar_image_url(user.email, size: 100, default: :retro, secure: true)
  end

  def project_icon(project)
    return source_identicon(project) unless project.avatar.attached?

    content_tag(:figure, class: 'image') do
      image_tag project.avatar.variant(resize: '100x100!')
    end
  end

  private

  def source_identicon(project)
    content_tag(:div, class: "identicon bg#{(project.id % 7) + 1}") do
      project.name.first.upcase
    end
  end
end
