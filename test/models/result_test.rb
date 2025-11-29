# frozen_string_literal: true

require 'test_helper'

class ResultTest < ActiveSupport::TestCase
  test 'duplicate result shows translated uniqueness error' do
    result = results(:encounter_distance_close)

    dupe = result.roll.results.build(
      result
      .attributes
      .except('id', 'created_at', 'updated_at')
    )

    assert_not dupe.valid?, 'Duplicate result should be invalid'

    expected_message = I18n.t(
      'activerecord.errors.models.result.attributes.value.taken'
    )

    assert_includes dupe.errors[:value], expected_message
  end

  #   test 'result value must fall within roll dice range' do
  #     roll = rolls(:encounter_distance) # 2d6
  #
  #     result = roll.results.build(name: 'out of range', value: 13)
  #
  #     assert_not result.valid?,
  #                'Result with value out of range should be invalid'
  #
  #     assert_includes result.errors[:value],
  #                     "must be less than or equal to #{roll.dice_object.max}",
  #                     'Validation error should mention dice limit'
  #   end

  test '1d6 boars flee a hunting party of 2d4 territorial centaurs' do
    result = Roll.new.results.build(
      name: '1d6 boars flee a hunting party of 2d4 territorial centaurs'
    )

    assert_match(
      /\d boars flee a hunting party of \d territorial centaurs/,
      result.name_with_rolls
    )
  end

  test 'can discard a result' do
    result = results(:encounter_distance_close)

    assert_not result.discarded?
    result.discard
    assert result.discarded?
    assert_not_nil result.discarded_at
  end

  test 'can restore a discarded result' do
    result = results(:encounter_distance_close)
    result.discard

    assert result.discarded?
    result.undiscard
    assert_not result.discarded?
    assert_nil result.discarded_at
  end

  test 'discarded result is excluded from default scope' do
    result = results(:encounter_distance_close)
    result.discard

    assert_not_includes Result.kept, result
    assert_includes Result.with_discarded, result
  end
end
