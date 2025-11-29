# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

require 'mocha/minitest' # for stubbing

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all
  end
end

module ActionDispatch
  class IntegrationTest
    def login_as(user)
      ApplicationController.any_instance.stubs(:current_user).returns(user)
      Avo::ApplicationController.any_instance.stubs(:current_user).returns(user) if defined?(Avo::ApplicationController)
    end
  end
end
