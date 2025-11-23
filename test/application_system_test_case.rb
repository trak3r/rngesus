# frozen_string_literal: true

require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  def login_as(user)
    ApplicationController.any_instance.stubs(:current_user).returns(user)
  end
end
