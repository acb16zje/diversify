# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

Rails.application.config.content_security_policy do |policy|
  policy.default_src     :none
  policy.connect_src     :self
  policy.form_action     :self
  policy.frame_ancestors :none
  policy.frame_src       'https://www.google.com',
                         'https://www.facebook.com',
                         'https://platform.twitter.com'
  policy.img_src         :self, :https, :data, :blob
  policy.manifest_src    :self
  policy.style_src       :self, :unsafe_inline

  # If you are using webpack-dev-server then specify webpack-dev-server host
  if Rails.env.development?
    policy.script_src  :self, :https, :unsafe_eval
    policy.connect_src :self, 'http://localhost:3035', 'ws://localhost:3035'
  else
    policy.script_src  :self, :https
  end

  # Specify URI for violation reports
  # policy.report_uri "/csp-violation-report-endpoint"
end

Rails.application.config.content_security_policy.block_all_mixed_content

# If you are using UJS then enable automatic nonce generation
Rails.application.config.content_security_policy_nonce_generator =
  ->(_request) { SecureRandom.base64(16) }

# Set the nonce only to specific directives
Rails.application.config.content_security_policy_nonce_directives = %w[script-src]

# Report CSP violations to a specified URI
# For further information see the following documentation:
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only
# Rails.application.config.content_security_policy_report_only = true
