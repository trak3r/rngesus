require "test_helper"

class ResultTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "result value must fall within roll dice range" do
    roll = rolls :distance # d6

    roll.results.build(name: 'out of range',
                       value: 7)

    assert_not rolls.save,
      "Roll with value out of range should not save"

    assert rolls.errors[:value],
      "Validation error should be on value"
  end
end
