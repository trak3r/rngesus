# frozen_string_literal: true

require 'test_helper'

class RollsActiveTabTest < ActionDispatch::IntegrationTest
  test 'header nav updates when switching tabs' do
    open_session do |s|
      s.login_as(users(:ted))

      # 1. Load initial page (newest tab)
      s.get rolls_url(tab: 'newest')
      s.assert_response :success
      s.assert_select '#nav_tab_newest.bg-base-300'
      s.assert_select '#nav_tab_most_liked:not(.bg-base-300)'
      
      # Verify Morphing meta tags are present
      s.assert_select 'meta[name="turbo-refresh-method"][content="morph"]'
      s.assert_select 'meta[name="turbo-refresh-scroll"][content="preserve"]'

      # Verify that links do NOT have data-turbo-stream="true"
      s.assert_select '#nav_tab_most_liked:not([data-turbo-stream="true"])'
      s.assert_select '#header_search_form:not([data-turbo-stream="true"])'

      # 2. Switch to most_liked (standard GET request)
      # In a real browser this triggers a Visit, in integration test it's just a GET
      s.get rolls_url(tab: 'most_liked')
      s.assert_response :success
      
      # URL should represent the new state
      s.assert_equal rolls_path(tab: 'most_liked'), s.request.fullpath

      # Check for the active class in the response body
      s.assert_select '#nav_tab_most_liked.bg-base-300'
      s.assert_select '#nav_tab_newest:not(.bg-base-300)'

      # 3. Simulate navigation from a non-index page
      s.get roll_url(rolls(:encounter_distance))
      s.assert_response :success
      s.assert_select '#nav_tab_newest:not([data-turbo-stream="true"])'
    end
  end
end

