# frozen_string_literal: true

module UserHelper
  Title = {google_oauth2: 'Google',facebook: 'Facebook',twitter: 'Twitter'}

  def social_btn(provider)
    return social_btn_class(provider), social_btn_text(provider), social_btn_icon(provider)
  end

  def social_btn_class(provider)
    current_user.oauth?(provider) ? 'is-danger button' : 'button'
  end

  def social_btn_text(provider)
    if current_user.oauth?(provider)
      "Disconnect with #{Title[provider]}"
    else 
      "Connect with #{Title[provider]}"
    end
  end

  def social_btn_icon(provider)
    case provider.to_s
    when 'google_oauth2'
      'flat-color-icons:google'
    when 'facebook'
      'logos:facebook'
    when 'twitter'
      'logos:twitter'
    end
  end
end