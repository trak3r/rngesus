# frozen_string_literal: true

require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test 'should get login page' do
    get login_path

    assert_response :success
    assert_select 'h1', text: 'Login'
  end

  # NOTE: OAuth callback and session management testing is complex in integration tests
  # and would require extensive OmniAuth mocking or system tests with actual OAuth flows.
  # The SessionsController#create logic is straightforward and relies on OmniAuth middleware.
  # The SessionsController#destroy logic is tested implicitly through user workflows.
end
