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
      
      # Verify that links HAVE data-turbo-stream="true"
      s.assert_select '#nav_tab_most_liked[data-turbo-stream="true"]'
      s.assert_select '#header_search_form[data-turbo-stream="true"]'

      # 2. Switch to most_liked via turbo_stream (as the links now do)
      s.get rolls_url(tab: 'most_liked'), as: :turbo_stream
      s.assert_response :success
      
      # Check that the turbo-stream for header_nav is present at the top level
      s.assert_match(/<turbo-stream action="replace" target="header_nav">/, s.response.body)
      
      # Check for the active class in the response body
      s.assert_match(/id="nav_tab_most_liked" class=".*bg-base-300"/, s.response.body)

      # 3. Simulate navigation from a non-index page (should NOT use turbo-stream)
      s.get roll_url(rolls(:encounter_distance))
      s.assert_response :success
      s.assert_select '#nav_tab_newest[data-turbo-stream]:not([data-turbo-stream="true"])', count: 0
      # Actually, better to check it does NOT have it
      s.assert_select '#nav_tab_newest:not([data-turbo-stream="true"])'
    end
  end
end

