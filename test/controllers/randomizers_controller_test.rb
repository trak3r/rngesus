# frozen_string_literal: true

require 'test_helper'

class RandomizersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @randomizer = randomizers(:encounter)
    RandomizersController
      .any_instance
      .stubs(:current_user)
      .returns(User.first)
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

  # Authorization tests
  test 'owner can edit their randomizer' do
    get edit_randomizer_url(@randomizer)

    assert_response :success
  end

  test 'non-owner cannot edit randomizer' do
    other_user = User.create!(provider: 'google', uid: '99999', email: 'other@example.com')
    RandomizersController.any_instance.stubs(:current_user).returns(other_user)

    get edit_randomizer_url(@randomizer)

    assert_redirected_to randomizers_path
    assert_equal "You don't have permission to do that.", flash[:alert]
  end

  test 'non-owner cannot update randomizer' do
    other_user = User.create!(provider: 'google', uid: '99998', email: 'another@example.com')
    RandomizersController.any_instance.stubs(:current_user).returns(other_user)

    patch randomizer_url(@randomizer), params: { randomizer: { name: 'Updated Name' } }

    assert_redirected_to randomizers_path
    assert_equal "You don't have permission to do that.", flash[:alert]
  end

  test 'non-owner cannot destroy randomizer' do
    other_user = User.create!(provider: 'google', uid: '99997', email: 'yetanother@example.com')
    RandomizersController.any_instance.stubs(:current_user).returns(other_user)

    assert_no_difference('Randomizer.count') do
      delete randomizer_url(@randomizer)
    end
    assert_redirected_to randomizers_path
    assert_equal "You don't have permission to do that.", flash[:alert]
  end
end
