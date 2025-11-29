# frozen_string_literal: true

require 'test_helper'

class ResultsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @result = results(:encounter_distance_close)
    login_as(@result.roll.randomizer.user)
  end

  test 'should get index' do
    get roll_results_url(@result.roll)

    assert_response :success
  end

  test 'should get new' do
    get new_roll_result_url(@result.roll)

    assert_response :success
  end

  test 'should create result' do
    assert_difference('Result.count') do
      post roll_results_url(@result.roll), params: { result: {
        name: 'far',
        value: 2
      } }
    end

    assert_redirected_to result_url(Result.last)
  end

  test 'should show result' do
    get result_url(@result)

    assert_response :success
  end

  test 'should get edit' do
    get edit_result_url(@result)

    assert_response :success
  end

  test 'should update result' do
    patch result_url(@result), params: { result: {
      name: 'far',
      value: 2
    } }

    assert_redirected_to result_url(@result)
  end

  test 'should discard result (soft delete)' do
    assert_not @result.discarded?
    assert_no_difference('Result.with_discarded.count') do
      delete result_url(@result)
    end

    @result.reload

    assert_predicate @result, :discarded?
    assert_not_nil @result.discarded_at
    assert_redirected_to roll_url(@result.roll)
  end

  # Authorization tests
  test 'non-owner cannot edit result' do
    other_user = users(:other_user)
    ResultsController.any_instance.stubs(:current_user).returns(other_user)

    get edit_result_url(@result)

    assert_redirected_to randomizers_path
    assert_equal "You don't have permission to do that.", flash[:alert]
  end

  test 'non-owner cannot update result' do
    other_user = users(:other_user)
    ResultsController.any_instance.stubs(:current_user).returns(other_user)

    patch result_url(@result), params: { result: { name: 'Updated Result' } }

    assert_redirected_to randomizers_path
    assert_equal "You don't have permission to do that.", flash[:alert]
  end

  test 'non-owner cannot destroy result' do
    other_user = users(:other_user)
    ResultsController.any_instance.stubs(:current_user).returns(other_user)

    assert_not @result.discarded?
    assert_no_difference('Result.with_discarded.count') do
      delete result_url(@result)
    end
    @result.reload

    assert_not @result.discarded?
    assert_redirected_to randomizers_path
    assert_equal "You don't have permission to do that.", flash[:alert]
  end
end
