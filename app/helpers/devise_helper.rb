# frozen_string_literal: true

# Helper for devise authentication
module DeviseHelper
  PROVIDERS = {
    google_oauth2: {
      label: 'Google',
      icon: 'flat-color-icons:google'
    },
    facebook: {
      label: 'Facebook',
      icon: 'fe:facebook'
    },
    twitter: {
      label: 'Twitter',
      icon: 'fe:twitter'
    }
  }.freeze

  def provider_label(provider)
    PROVIDERS[provider][:label]
  end

  def provider_icon(provider)
    PROVIDERS[provider][:icon]
  end
end
