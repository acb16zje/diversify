# frozen_string_literal: true

# Helper for showing avatar images
module AvatarHelper
  include Rails.application.routes.url_helpers
  include GravatarImageTag

  def user_avatar(user)
    if user.avatar.attached?
      rails_representation_url(user.avatar.variant(resize: '100x100!'))
    else
      gravatar_image_url(user.email, size: 100, default: :retro, secure: true)
    end
  end

  def project_icon(project)
    return source_identicon(project) unless project.avatar.attached?

    content_tag(:figure, class: 'image') do
      image_tag rails_representation_url(project.avatar.variant(resize: '100x100!')), alt: 'Project avatar'
    end
  end

  def get_avatars(ids)
    arr = {}
    User.find(ids).each do |u|
      arr[u.id] = u.avatar.attached? ? url_for(user_avatar(u)) : user_avatar(u)
    end
    arr
  end

  private

  def source_identicon(project)
    content_tag(:div, class: "identicon bg#{(project.id % 7) + 1}") do
      project.name.first.upcase
    end
  end

  def default_url_options
    { only_path: true }
  end
end
