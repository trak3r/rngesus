# frozen_string_literal: true

require 'test_helper'

class ResultTest < ActiveSupport::TestCase
  test 'result value must fall within roll dice range' do
    roll = rolls(:encounter_distance) # 2d6

    result = roll.results.build(name: 'out of range', value: 13)

    assert_not result.valid?,
               'Result with value out of range should be invalid'

    assert_includes result.errors[:value],
                    "must be less than or equal to #{roll.dice_object.max}",
                    'Validation error should mention dice limit'
  end
end
