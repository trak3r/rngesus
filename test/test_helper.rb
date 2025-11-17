# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

OmniAuth.config.test_mode = true

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    def mock_auth_hash(provider: :github, uid: "12345", info: {})
      OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new({
        provider: provider.to_s,
        uid: uid,
        info: {
          name: info[:name] || "Test User",
          email: info[:email] || "test@example.com"
        }
      })
    end

  end
end
