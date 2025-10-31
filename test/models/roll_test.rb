require "test_helper"

class RollTest < ActiveSupport::TestCase
  test "should not save roll without name" do
    r = Randomizer.create!(name: "TestRandomizer")
    roll = Roll.new(value: 3, randomizer: r)
    assert_not roll.save, "Saved the roll without a name"
  end

  test "should save roll with name and value" do
    r = Randomizer.create!(name: "TestRandomizer")
    roll = Roll.new(value: 4, name: "My Roll", randomizer: r)
    assert roll.save
  end
end
