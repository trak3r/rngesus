# frozen_string_literal: true

require 'test_helper'

class RandomizersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @randomizer = randomizers(:encounter)
    RandomizersController
      .any_instance
      .stubs(:current_user)
      .returns(users(:ted))
  end

  test 'should get index' do
    get randomizers_url

    assert_response :success
  end

  test 'should get index with multiple tags' do
    get randomizers_url, params: { tags: %w[Dungeon Magic], tab: 'newest' }

    assert_response :success
    # Treasure Hunt has Dungeon and Magic
    assert_select 'body', text: /Treasure Hunt/
    # Dungeon Crawler has Dungeon but not Magic
    assert_select 'body', text: /Dungeon Crawler/, count: 0
  end

  test 'should get new' do
    get new_randomizer_url

    assert_response :success
  end

  test 'should create randomizer' do
    assert_difference('Randomizer.count') do
      post randomizers_url, params: { randomizer: {
        name: 'Forest Encounters'
      } }
    end

    assert_redirected_to randomizer_outcomes_path(Randomizer.last)
  end

  test 'should show randomizer' do
    get randomizer_url(@randomizer)

    assert_response :success
  end

  test 'should get edit' do
    get edit_randomizer_url(@randomizer)

    assert_response :success
  end

  test 'should update randomizer' do
    patch randomizer_url(@randomizer), params: { randomizer: {
      name: 'Forest Encounters'
    } }

    assert_redirected_to randomizer_url(@randomizer)
  end

  test 'should discard randomizer (soft delete)' do
    assert_not @randomizer.discarded?
    assert_no_difference('Randomizer.with_discarded.count') do
      delete randomizer_url(@randomizer)
    end

    @randomizer.reload

    assert_predicate @randomizer, :discarded?
    assert_not_nil @randomizer.discarded_at
    assert_redirected_to randomizers_url
  end

  test 'should discard randomizer and redirect to specific tab' do
    assert_not @randomizer.discarded?
    assert_no_difference('Randomizer.with_discarded.count') do
      delete randomizer_url(@randomizer), params: { tab: 'your_randomizers' }
    end

    @randomizer.reload

    assert_predicate @randomizer, :discarded?
    assert_redirected_to randomizers_url(tab: 'your_randomizers')
  end

  # Authorization tests
  test 'owner can edit their randomizer' do
    get edit_randomizer_url(@randomizer)

    assert_response :success
  end

  test 'non-owner cannot edit randomizer' do
    other_user = users(:other_user)
    RandomizersController.any_instance.stubs(:current_user).returns(other_user)

    get edit_randomizer_url(@randomizer)

    assert_redirected_to randomizers_path
    assert_equal "You don't have permission to do that.", flash[:alert]
  end

  test 'non-owner cannot update randomizer' do
    other_user = users(:other_user)
    RandomizersController.any_instance.stubs(:current_user).returns(other_user)

    patch randomizer_url(@randomizer), params: { randomizer: { name: 'Updated Name' } }

    assert_redirected_to randomizers_path
    assert_equal "You don't have permission to do that.", flash[:alert]
  end

  test 'non-owner cannot destroy randomizer' do
    other_user = users(:other_user)
    RandomizersController.any_instance.stubs(:current_user).returns(other_user)

    assert_not @randomizer.discarded?
    assert_no_difference('Randomizer.with_discarded.count') do
      delete randomizer_url(@randomizer)
    end
    @randomizer.reload

    assert_not @randomizer.discarded?
    assert_redirected_to randomizers_path
    assert_equal "You don't have permission to do that.", flash[:alert]
  end

  test 'discarded randomizer is excluded from index' do
    @randomizer.discard!
    get randomizers_url

    assert_response :success
    # Discarded randomizer should not appear in the list
    assert_select 'body', text: /#{@randomizer.name}/, count: 0
  end

  test 'should create randomizer with multiple tags' do
    assert_difference('Randomizer.count') do
      post randomizers_url, params: { randomizer: {
        name: 'Multi-Tag Randomizer',
        tag_ids: [tags(:forest).id, tags(:dungeon).id]
      } }
    end

    randomizer = Randomizer.last

    assert_equal 2, randomizer.tags.count
    assert_includes randomizer.tags, tags(:forest)
    assert_includes randomizer.tags, tags(:dungeon)
    assert_redirected_to randomizer_outcomes_path(randomizer)
  end

  test 'should create randomizer with 3 tags (maximum)' do
    assert_difference('Randomizer.count') do
      post randomizers_url, params: { randomizer: {
        name: 'Three Tag Randomizer',
        tag_ids: [tags(:forest).id, tags(:dungeon).id, tags(:monster).id]
      } }
    end

    randomizer = Randomizer.last

    assert_equal 3, randomizer.tags.count
    assert_redirected_to randomizer_outcomes_path(randomizer)
  end

  test 'should not create randomizer with more than 3 tags' do
    assert_no_difference('Randomizer.count') do
      post randomizers_url, params: { randomizer: {
        name: 'Too Many Tags',
        tag_ids: [tags(:forest).id, tags(:dungeon).id, tags(:monster).id, tags(:magic).id]
      } }
    end

    assert_response :unprocessable_content
  end

  test 'should update existing roll via nested attributes instead of creating new one' do
    # Get the existing roll
    roll = @randomizer.rolls.first
    original_roll_id = roll.id
    original_roll_name = roll.name
    original_roll_dice = roll.dice

    # Update randomizer with nested roll attributes (simulating wizard flow)
    assert_no_difference('Roll.count') do
      patch randomizer_url(@randomizer), params: { randomizer: {
        name: @randomizer.name,
        method: 'upload', # Include method to simulate wizard flow
        rolls_attributes: {
          '0' => {
            id: roll.id,
            name: 'Updated Roll Name',
            dice: 'D20'
          }
        }
      } }
    end

    assert_redirected_to randomizer_outcomes_path(@randomizer)

    # Verify the roll was updated, not replaced
    roll.reload

    assert_equal original_roll_id, roll.id, 'Roll ID should not change'
    assert_equal 'Updated Roll Name', roll.name, 'Roll name should be updated'
    assert_equal 'D20', roll.dice, 'Roll dice should be updated'
    assert_not_equal original_roll_name, roll.name
    assert_not_equal original_roll_dice, roll.dice
  end
end
