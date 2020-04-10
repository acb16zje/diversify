# frozen_string_literal: true

Rails.application.configure do
  config.action_dispatch.default_headers['Feature-Policy'] = %w[
      accelerometer 'none';
      ambient-light-sensor 'none';
      autoplay 'none';
      battery 'none';
      camera 'none';
      document-domain 'none';
      encrypted-media 'none';
      execution-while-not-rendered 'none';
      execution-while-out-of-viewport 'none';
      fullscreen 'none';
      geolocation 'none';
      gyroscope 'none';
      layout-animations 'self';
      legacy-image-formats 'none';
      magnetometer 'none';
      microphone 'none';
      midi 'none';
      oversized-images 'self';
      payment 'none';
      picture-in-picture 'none';
      publickey-credentials 'none';
      sync-xhr 'none';
      unoptimized-images 'none';
      unsized-media 'self';
      usb 'none';
      vibrate 'none';
      vr 'none';
      xr-spatial-tracking 'none';
    ].join(' ')
end
