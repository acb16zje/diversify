# frozen_string_literal: true

# OAuth support module for RSpec testing
module OAuthHelper
  def hash(provider, email = generate(:email))
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(
      provider: provider,
      uid: '1234',
      info: {
        email: email,
        name: generate(:name),
        image: 'spec/fixtures/squirtle.png'
      }
    )
  end
end
