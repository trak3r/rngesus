require "test_helper"

class RandomizerTest < ActiveSupport::TestCase
  test "should not save randomizer without name" do
    randomizer = Randomizer.new
    assert_not randomizer.save, "Saved the randomizer without a name"
  end
end
