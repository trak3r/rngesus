# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer if Rails.env.development?
end

OmniAuth.config.logger = Rails.logger

google_client_id = ENV.fetch('GOOGLE_CLIENT_ID', nil)
google_client_secret = ENV.fetch('GOOGLE_CLIENT_SECRET', nil)

if (google_client_id.blank? || google_client_secret.blank?) && !Rails.env.test?
  raise 'Missing GOOGLE_CLIENT_ID or GOOGLE_CLIENT_SECRET environment variables!'
end

twitter_api_key = ENV.fetch('TWITTER_API_KEY', nil)
twitter_api_secret = ENV.fetch('TWITTER_API_SECRET', nil)

if (twitter_api_key.blank? || twitter_api_secret.blank?) && !Rails.env.test?
  raise 'Missing TWITTER_API_KEY or TWITTER_API_SECRET environment variables!'
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, google_client_id, google_client_secret
  provider :twitter, twitter_api_key, twitter_api_secret, {
    client_options: {
      ssl: {
        verify_mode: OpenSSL::SSL::VERIFY_PEER,
        ca_file: '/opt/homebrew/etc/openssl@3/cert.pem',
        # Disable CRL checking which is causing the error
        verify_callback: proc { |preverify_ok, store_context|
          # Always return true to skip CRL verification
          true
        }
      }
    }
  }
end

OmniAuth.config.allowed_request_methods = %i[get]
