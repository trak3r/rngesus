# frozen_string_literal: true

require 'test_helper'

class DiceTest < ActiveSupport::TestCase
  test '3d6+2' do
    dice = Dice.new '3d6+2'

    assert_kind_of SummedDiceNotation, dice
    assert_equal 3, dice.multiplier
    assert_equal 6, dice.face
    assert_equal 2, dice.modifier
    assert_equal 5, dice.min
    assert_equal 20, dice.max

    assert_operator dice.roll, :>=, dice.min
    assert_operator dice.roll, :<=, dice.max
  end

  test 'd2' do
    dice = Dice.new 'd2'

    assert_kind_of SummedDiceNotation, dice
    assert_equal 1, dice.multiplier
    assert_equal 2, dice.face
    assert_equal 0, dice.modifier
    assert_equal 1, dice.min
    assert_equal 2, dice.max

    assert_operator dice.roll, :>=, dice.min
    assert_operator dice.roll, :<=, dice.max
  end

  test '1d6 boars flee a hunting party of 2d4 territorial centaurs' do
    dices = Dice.from '1d6 boars flee a hunting party of 2d4 territorial centaurs'

    assert_equal '1d6', dices.first.name
    assert_equal '2d4', dices.last.name
  end

  test 'd66 sequence dice' do
    dice = Dice.new 'd66'
    
    assert_kind_of SequenceDiceNotation, dice
    assert_equal 11, dice.min
    assert_equal 66, dice.max
    
    roll = dice.roll
    assert_operator roll, :>=, 11
    assert_operator roll, :<=, 66
  end

  test 'd40 sequence dice' do
    dice = Dice.new 'd40'
    
    assert_kind_of SequenceDiceNotation, dice
    # d4 (1-4) and d10 (0-9)
    # Min: 10. Max: 49.
    assert_equal 10, dice.min
    assert_equal 49, dice.max
    
    roll = dice.roll
    assert_operator roll, :>=, 10
    assert_operator roll, :<=, 49
  end

  test 'd100 remains summed dice' do
    dice = Dice.new 'd100'
    assert_kind_of SummedDiceNotation, dice
    assert_equal 1, dice.min
    assert_equal 100, dice.max
  end

  test 'd20 remains summed dice' do
    dice = Dice.new 'd20'
    assert_kind_of SummedDiceNotation, dice
  end

  test 'd12 remains summed dice' do
    dice = Dice.new 'd12'
    assert_kind_of SummedDiceNotation, dice
  end
end
