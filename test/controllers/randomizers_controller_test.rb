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

    assert_redirected_to randomizer_url(Randomizer.last)
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

  test 'should destroy randomizer' do
    assert_difference('Randomizer.count', -1) do
      delete randomizer_url(@randomizer)
    end

    assert_redirected_to randomizers_url
  end

  test 'should destroy randomizer and redirect to specific tab' do
    assert_difference('Randomizer.count', -1) do
      delete randomizer_url(@randomizer), params: { tab: 'your_randomizers' }
    end

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

    assert_no_difference('Randomizer.count') do
      delete randomizer_url(@randomizer)
    end
    assert_redirected_to randomizers_path
    assert_equal "You don't have permission to do that.", flash[:alert]
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
    assert_redirected_to randomizer_url(randomizer)
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
    assert_redirected_to randomizer_url(randomizer)
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
end
