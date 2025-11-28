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

twitter_client_id = ENV.fetch('TWITTER_CLIENT_ID', nil)
twitter_client_secret = ENV.fetch('TWITTER_CLIENT_SECRET', nil)

if (twitter_client_id.blank? || twitter_client_secret.blank?) && !Rails.env.test?
  raise 'Missing TWITTER_CLIENT_ID or TWITTER_CLIENT_SECRET environment variables!'
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, google_client_id, google_client_secret
  provider :twitter2, twitter_client_id, twitter_client_secret,
    scope: 'tweet.read users.read'
end

OmniAuth.config.allowed_request_methods = %i[get]
