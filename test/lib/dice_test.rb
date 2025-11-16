# frozen_string_literal: true

require 'test_helper'

class DiceTest < ActiveSupport::TestCase
  test '3d6+2' do
    dice = Dice.new '3d6+2'

    assert_equal 3, dice.multipler
    assert_equal 6, dice.face
    assert_equal 2, dice.modifier
    assert_equal 5, dice.min
    assert_equal 20, dice.max

    assert_operator dice.roll, :>=, dice.min
    assert_operator dice.roll, :<=, dice.max
  end

  test 'd2' do
    dice = Dice.new 'd2'

    assert_equal 1, dice.multipler
    assert_equal 2, dice.face
    assert_equal 0, dice.modifier
    assert_equal 1, dice.min
    assert_equal 2, dice.max

    assert_operator dice.roll, :>=, dice.min
    assert_operator dice.roll, :<=, dice.max
  end
end
