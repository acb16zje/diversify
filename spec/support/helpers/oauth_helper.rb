# frozen_string_literal: true

# OAuth support module for RSpec testing
module OAuthHelper
  def hash(provider, email = generate(:email))
    OmniAuth.config.mock_auth[to_symbol(provider)] = OmniAuth::AuthHash.new(
      provider: provider,
      uid: '1234',
      info: {
        email: email,
        name: generate(:name),
        image: Rails.root.join('app/assets/images/avatar/small/ade.jpg')
      }
    )
  end

  def to_symbol(provider)
    provider.parameterize.underscore.to_sym
  end
end
