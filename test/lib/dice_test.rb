require "test_helper"

class DiceTest < ActiveSupport::TestCase
  test "quirky dice combinations" do
    assert_equal 1, Dice.find("D6").min
    assert_equal 2, Dice.find("2D6").min
    assert_equal 1, Dice.find("D100").min
    assert_equal 100, Dice.find("D100").max
  end
end
