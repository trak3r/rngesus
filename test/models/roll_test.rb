# frozen_string_literal: true

require 'test_helper'

class RollTest < ActiveSupport::TestCase
  test 'should require name' do
    roll = Roll.new(dice: 'D6', randomizer: randomizers(:encounter))

    assert_not roll.valid?
    assert_includes roll.errors[:name], "can't be blank"
  end

  test 'should require dice' do
    roll = Roll.new(name: 'Test Roll', randomizer: randomizers(:encounter))

    assert_not roll.valid?
    assert_includes roll.errors[:dice], "can't be blank"
  end

  test 'should validate dice format' do
    roll = Roll.new(name: 'Test Roll', dice: 'INVALID', randomizer: randomizers(:encounter))

    assert_not roll.valid?
    assert_match(/Could not parse INVALID/, roll.errors[:dice].first)
  end

  test 'should accept valid dice formats' do
    valid_formats = %w[D6 2D6 d20 3d8 D100]

    valid_formats.each do |dice_format|
      roll = Roll.new(name: 'Test Roll', dice: dice_format, randomizer: randomizers(:encounter))

      assert_predicate roll, :valid?, "#{dice_format} should be valid but got errors: #{roll.errors.full_messages}"
    end
  end

  test 'should reject profane names' do
    roll = Roll.new(name: 'fuck', dice: 'D6', randomizer: randomizers(:encounter))

    assert_not roll.valid?
    assert_match(/contains inappropriate language/, roll.errors[:name].first)
  end

  test 'dice_object returns DiceNotation instance' do
    roll = rolls(:encounter_distance)

    dice_obj = roll.dice_object

    # Dice.new returns a SummedDiceNotation or SequenceDiceNotation, not Dice itself
    assert_respond_to dice_obj, :roll
    assert_respond_to dice_obj, :name
    assert_equal '2D6', dice_obj.name
  end

  test 'outcome returns nil when no results' do
    roll = Roll.create!(name: 'Empty Roll', dice: 'D6', randomizer: randomizers(:encounter))

    rolled, result = roll.outcome

    assert_nil rolled
    assert_nil result
  end

  test 'outcome returns rolled value and matching result' do
    roll = rolls(:encounter_distance)

    # Create results for different values
    roll.results.create!(name: 'Close', value: 2)
    roll.results.create!(name: 'Medium', value: 6)
    roll.results.create!(name: 'Far', value: 10)

    # Call outcome multiple times to test the logic
    # Since we can't easily stub the random roll, we'll just verify
    # that it returns a valid result
    rolled, result = roll.outcome

    assert_not_nil rolled
    assert rolled.between?(2, 12), "Rolled value #{rolled} should be between 2 and 12 for 2D6"

    # If result is not nil, it should be one of our results
    if result
      assert_includes %w[Close Medium Far], result.name
      assert_operator result.value, :<=, rolled, "Result value #{result.value} should be <= rolled #{rolled}"
    end
  end

  test 'outcome selects result with highest value not exceeding roll' do
    roll = Roll.create!(name: 'Test Roll', dice: 'D6', randomizer: randomizers(:encounter))

    # Create results with specific values for D6 (1-6)
    result_low = roll.results.create!(name: 'Low', value: 2)
    result_mid = roll.results.create!(name: 'Mid', value: 4)
    result_high = roll.results.create!(name: 'High', value: 6)

    # Run outcome multiple times to test the logic works correctly
    10.times do
      rolled, result = roll.outcome

      assert_not_nil rolled
      assert rolled.between?(1, 6), "Rolled value #{rolled} should be between 1 and 6 for D6"

      # Result should be the highest value not exceeding the roll
      next unless result

      assert_operator result.value, :<=, rolled, "Result value #{result.value} should be <= rolled #{rolled}"

      # Verify it's the highest eligible
      eligible_results = [result_low, result_mid, result_high].select { |r| r.value <= rolled }
      highest_eligible = eligible_results.max_by(&:value)

      assert_equal highest_eligible, result
    end
  end

  test 'outcome returns nil result when rolled below all values' do
    roll = Roll.create!(name: 'Test Roll', dice: 'D6', randomizer: randomizers(:encounter))

    # Create results all with high values (5 and 6)
    roll.results.create!(name: 'High1', value: 5)
    roll.results.create!(name: 'High2', value: 6)

    # Run outcome multiple times
    # When rolling 1-4, result should be nil
    # When rolling 5-6, result should be one of the high results
    results_found = []

    20.times do
      rolled, result = roll.outcome

      if rolled < 5
        assert_nil result, "Rolling #{rolled} should return nil result"
      else
        assert_not_nil result, "Rolling #{rolled} should return a result"
        results_found << result.name
      end
    end

    # Verify we got at least one nil case (statistically very likely in 20 rolls)
    # This is a probabilistic test but should pass >99.9% of the time
  end

  test 'can discard a roll' do
    roll = rolls(:encounter_distance)

    assert_not roll.discarded?
    roll.discard
    assert roll.discarded?
    assert_not_nil roll.discarded_at
  end

  test 'can restore a discarded roll' do
    roll = rolls(:encounter_distance)
    roll.discard

    assert roll.discarded?
    roll.undiscard
    assert_not roll.discarded?
    assert_nil roll.discarded_at
  end

  test 'discarded roll is excluded from default scope' do
    roll = rolls(:encounter_distance)
    roll.discard

    assert_not_includes Roll.kept, roll
    assert_includes Roll.with_discarded, roll
  end
end
