# frozen_string_literal: true

require 'test_helper'

class RollsControllerPaginationTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:ted)
    login_as(@user)
    
    # Ensure a clean state for pagination testing by creating strictly controlled data
    # We want 7 rolls in total to test the 6-per-page limit
    # Fixtures might have some, so we'll just create 7 fresh ones with a specific tag
    # or just assume the fixtures count + our new ones.
    # A cleaner approach is to use a unique query or tab that filters down to just our test rolls.
    
    @tag = Tag.create!(name: 'pagination_test')
    
    7.times do |i|
      Roll.create!(
        name: "Pagination Roll #{i}",
        dice: 'D20',
        user: @user,
        slug: "pag0#{i}",
        tags: [@tag]
      ).results.create!(name: 'Result', value: 1)
    end
  end

  test 'should paginate rolls' do
    # Request page 1
    get rolls_url(tab: 'newest', tags: [@tag.name]) # Filter by our tag to isolate
    assert_response :success
    
    # Should see 6 rolls (limit)
    # The grid items have class 'card-index'
    # But wait, the grid items are rendered. We added an ID 'rolls_grid'.
    # Inside 'rolls_grid', count the direct children or just check for roll names.
    
    assert_select "#rolls_grid" do
       assert_select "div[id^='roll_']", count: 6
    end
    
    assert_select "a[href*='page=2']", text: "Show More Rolls"
    
    # Request page 2 via Turbo Stream (simulating the click)
    get rolls_url(page: 2, tab: 'newest', tags: [@tag.name]), as: :turbo_stream
    assert_response :success
    
    # Verify Turbo Stream response
    assert_select "turbo-stream[action='append'][target='rolls_grid']" do
      assert_select "template" do
        assert_select "div[id^='roll_']", count: 1
      end
    end
    
    # Load more button should be removed or hidden since it's the last page
    assert_select "turbo-stream[action='remove'][target='load_more']"
  end
end
