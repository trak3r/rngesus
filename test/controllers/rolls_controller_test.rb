# frozen_string_literal: true

require 'test_helper'

class RollsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @roll = rolls(:encounter_distance)
    login_as(@roll.randomizer.user)
  end

  test 'should get index' do
    get randomizer_rolls_url(@roll.randomizer)

    assert_response :success
  end

  test 'should get new' do
    get new_randomizer_roll_url(@roll.randomizer)

    assert_response :success
  end

  test 'should create roll' do
    assert_difference('Roll.count') do
      post randomizer_rolls_url(@roll.randomizer), params: { roll: {
        name: 'Mood',
        dice: '2D6'
      } }
    end

    assert_redirected_to roll_url(Roll.last)
  end

  test 'should show roll' do
    get roll_url(@roll)

    assert_response :success
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

  test 'should destroy roll' do
    assert_difference('Roll.count', -1) do
      delete roll_url(@roll)
    end

    # assert_redirected_to rolls_url
    assert_redirected_to randomizer_rolls_url(@roll.randomizer)
  end

  # Authorization tests
  test 'non-owner cannot edit roll' do
    other_user = User.create!(provider: 'google', uid: '88888', email: 'another@example.com')
    RollsController.any_instance.stubs(:current_user).returns(other_user)
    
    get edit_roll_url(@roll)
    assert_redirected_to randomizers_path
    assert_equal "You don't have permission to do that.", flash[:alert]
  end

  test 'non-owner cannot update roll' do
    other_user = User.create!(provider: 'google', uid: '88887', email: 'yetanother@example.com')
    RollsController.any_instance.stubs(:current_user).returns(other_user)
    
    patch roll_url(@roll), params: { roll: { name: 'Updated Roll' } }
    assert_redirected_to randomizers_path
    assert_equal "You don't have permission to do that.", flash[:alert]
  end

  test 'non-owner cannot destroy roll' do
    other_user = User.create!(provider: 'google', uid: '88886', email: 'otheragain@example.com')
    RollsController.any_instance.stubs(:current_user).returns(other_user)
    
    assert_no_difference('Roll.count') do
      delete roll_url(@roll)
    end
    assert_redirected_to randomizers_path
    assert_equal "You don't have permission to do that.", flash[:alert]
  end
end
