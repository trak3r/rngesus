# frozen_string_literal: true

require 'test_helper'

class ResultsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @result = results(:encounter_distance_close)
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

  test 'should destroy result' do
    assert_difference('Result.count', -1) do
      delete result_url(@result)
    end

    assert_redirected_to roll_url(@result.roll)
  end
end
