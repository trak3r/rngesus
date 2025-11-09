require "test_helper"

class RollsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @roll = rolls(:encounter_distance)
  end

  test "should get index" do
    get randomizer_rolls_url(@roll.randomizer)
    assert_response :success
  end

  test "should get new" do
    get new_randomizer_roll_url(@roll.randomizer)
    assert_response :success
  end

  test "should create roll" do
    assert_difference("Roll.count") do
      post randomizer_rolls_url(@roll.randomizer), params: { roll: {
        name: "Mood",
      dice: "2D6"
      } }
    end

    assert_redirected_to roll_url(Roll.last)
  end

  test "should show roll" do
    get roll_url(@roll)
    assert_response :success
  end

  test "should get edit" do
    get edit_roll_url(@roll)
    assert_response :success
  end

  test "should update roll" do
    patch roll_url(@roll), params: { roll: {
      name: "Mood",
      dice: "2D6"
    } }
    assert_redirected_to roll_url(@roll)
  end

  test "should destroy roll" do
    assert_difference("Roll.count", -1) do
      delete roll_url(@roll)
    end

    assert_redirected_to rolls_url
  end
end
