# frozen_string_literal: true

module OAuthHelper
  def hash(provider, email = generate(:email))
  OmniAuth.config.mock_auth[to_symbol(provider)] = OmniAuth::AuthHash.new({
    provider: provider,
    uid: '1234',
    info: {
      email: email,
      name: generate(:name),
      image: "#{Rails.root}/spec/support/images/ade.jpg"
    }
  })
  end

  def to_symbol(provider)
    provider.parameterize.underscore.to_sym
  end
end
