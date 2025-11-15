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
end
