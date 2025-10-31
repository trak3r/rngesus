require "test_helper"

class RandomizersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @randomizer = randomizers(:one)
  end

  test "should get index" do
    get randomizers_url
    assert_response :success
  end

  test "should get new" do
    get new_randomizer_url
    assert_response :success
  end

  test "should create randomizer" do
    assert_difference("Randomizer.count") do
      post randomizers_url, params: { randomizer: {} }
    end

    assert_redirected_to randomizer_url(Randomizer.last)
  end

  test "should show randomizer" do
    get randomizer_url(@randomizer)
    assert_response :success
  end

  test "should get edit" do
    get edit_randomizer_url(@randomizer)
    assert_response :success
  end

  test "should update randomizer" do
    patch randomizer_url(@randomizer), params: { randomizer: {} }
    assert_redirected_to randomizer_url(@randomizer)
  end

  test "should destroy randomizer" do
    assert_difference("Randomizer.count", -1) do
      delete randomizer_url(@randomizer)
    end

    assert_redirected_to randomizers_url
  end
end
