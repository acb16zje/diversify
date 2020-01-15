# frozen_string_literal: true

# Helper for
module UserHelper
  PROVIDERS = {
    google_oauth2: {
      label: 'Google',
      icon: 'flat-color-icons:google'
    },
    facebook: {
      label: 'Facebook',
      icon: 'logos:facebook'
    },
    twitter: {
      label: 'Twitter',
      icon: 'logos:twitter'
    }
  }.freeze

  def social_btn(provider)
    return social_btn_class(provider), social_btn_label(provider), social_btn_icon(provider)
  end

  private

  def social_btn_class(provider)
    'has-text-danger has-text-weight-semibold' if current_user.oauth?(provider)
  end

  def social_btn_label(provider)
    PROVIDERS[provider][:label]
  end

  def social_btn_icon(provider)
    PROVIDERS[provider][:icon]
  end
end
