# frozen_string_literal: true

require 'test_helper'

class RollsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @roll = rolls(:encounter_distance)
    login_as(@roll.user)
  end

  test 'should get index' do
    get rolls_url

    assert_response :success
  end

  test 'should get index with tabs' do
    # Newest tab
    # Create a brand new roll to be the newest
    Roll.create!(
      name: 'The Newest Roll',
      dice: 'D20',
      user: users(:ted),
      slug: 'new01'
    )

    get rolls_url(tab: 'newest')

    assert_response :success
    assert_select 'a', text: /The Newest Roll/

    # Most Liked tab
    # Add votes to a specific roll
    liked_roll = rolls(:encounter_forest)
    liked_roll.liked_by users(:ted)
    liked_roll.liked_by users(:other_user)

    get rolls_url(tab: 'most_liked')

    assert_response :success
    assert_select 'a', text: /Monster/ # encounter_forest name

    # Your Rolls tab
    # Logged in as 'ted' (set in setup), should see ted's rolls but not other_user's
    get rolls_url(tab: 'your_rolls')

    assert_response :success
    assert_select 'a', text: /Distance/ # ted's roll
    assert_select 'a', text: /Other User Roll/, count: 0 # other_user's roll
  end

  test 'should redirect protected tabs if not logged in' do
    RollsController.any_instance.stubs(:current_user).returns(nil)

    get rolls_url(tab: 'your_rolls')

    assert_redirected_to '/login'
  end

  test 'should search rolls' do
    get rolls_url(query: 'Distance', tab: 'newest')

    assert_response :success
    assert_select 'h2.card-title', text: /Distance/
    assert_select 'h2.card-title', text: /Monster/, count: 0
  end

  test 'should get new' do
    get new_roll_url

    assert_response :success
  end

  test 'should get choose_method' do
    get choose_method_rolls_url

    assert_response :success
  end

  test 'should create roll' do
    assert_difference('Roll.count') do
      post rolls_url, params: { roll: {
        name: 'Mood',
        dice: '2D6'
      } }
    end

    assert_redirected_to roll_url(Roll.last)
  end

  test 'should create roll with nested results' do
    assert_difference('Roll.count') do
      assert_difference('Result.count', 2) do
        post rolls_url, params: { roll: {
          name: 'Complex Roll',
          dice: 'D6',
          results_attributes: {
            '0' => { name: 'Low', value: 1 },
            '1' => { name: 'High', value: 6 }
          }
        } }
      end
    end

    assert_redirected_to roll_url(Roll.last)
  end

  test 'should create roll via upload wizard' do
    assert_difference('Roll.count') do
      post create_with_img_upload_rolls_url
    end

    assert_redirected_to new_roll_results_img_path(Roll.last)
  end

  test 'should show roll' do
    get roll_url(@roll)

    assert_response :success
  end

  test 'should reroll roll' do
    post reroll_roll_url(@roll), as: :turbo_stream

    assert_response :success
  end

  test 'should toggle like' do
    # Ensure starting state: user has NOT liked the roll
    user = @roll.user
    @roll.unliked_by user

    # We check the direct Vote count to avoid caching update timing issues in tests
    assert_difference('ActsAsVotable::Vote.count', 1) do
      post toggle_like_roll_url(@roll), as: :turbo_stream
    end

    # Reload validation
    @roll.reload

    assert_equal 1, @roll.votes_for.where(voter: user).count

    assert_difference('ActsAsVotable::Vote.count', -1) do
      post toggle_like_roll_url(@roll), as: :turbo_stream
    end

    assert_equal 0, @roll.votes_for.where(voter: user).count
  end

  test 'should get edit' do
    get edit_roll_url(@roll)

    assert_response :success
  end

  test 'should update roll' do
    patch roll_url(@roll), params: { roll: {
      name: 'Mood',
      dice: '2D6'
    } }

    assert_redirected_to roll_url(@roll)
  end

  test 'should update roll with new nested results' do
    # Use a roll with no existing results
    empty_roll = rolls(:empty_roll)
    initial_count = empty_roll.results.count

    assert_difference('Result.count', 2) do
      patch roll_url(empty_roll), params: { roll: {
        name: empty_roll.name,
        dice: empty_roll.dice,
        results_attributes: {
          '0' => { name: 'New Result 1', value: 1 },
          '1' => { name: 'New Result 2', value: 2 }
        }
      } }
    end

    assert_redirected_to roll_url(empty_roll)
    empty_roll.reload

    assert_equal initial_count + 2, empty_roll.results.count
  end

  test 'should discard roll (soft delete)' do
    assert_not @roll.discarded?
    assert_no_difference('Roll.with_discarded.count') do
      delete roll_url(@roll)
    end

    @roll.reload

    assert_predicate @roll, :discarded?
    assert_not_nil @roll.discarded_at
    assert_redirected_to rolls_url
  end

  # Authorization tests
  test 'non-owner cannot edit roll' do
    other_user = users(:other_user)
    RollsController.any_instance.stubs(:current_user).returns(other_user)

    get edit_roll_url(@roll)

    assert_redirected_to rolls_path
    assert_equal "You don't have permission to do that.", flash[:alert]
  end

  test 'non-owner cannot update roll' do
    other_user = users(:other_user)
    RollsController.any_instance.stubs(:current_user).returns(other_user)

    patch roll_url(@roll), params: { roll: { name: 'Updated Roll' } }

    assert_redirected_to rolls_path
    assert_equal "You don't have permission to do that.", flash[:alert]
  end

  test 'non-owner cannot destroy roll' do
    other_user = users(:other_user)
    RollsController.any_instance.stubs(:current_user).returns(other_user)

    assert_not @roll.discarded?
    assert_no_difference('Roll.with_discarded.count') do
      delete roll_url(@roll)
    end
    @roll.reload

    assert_not @roll.discarded?
    assert_redirected_to rolls_path
    assert_equal "You don't have permission to do that.", flash[:alert]
  end
end
