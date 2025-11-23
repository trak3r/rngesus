# frozen_string_literal: true

require 'test_helper'

class OutcomesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @randomizer = randomizers(:encounter)
    @roll = rolls(:encounter_distance)
    
    # Ensure the roll has at least one result for testing
    @roll.results.create!(name: 'Test Result', value: 5) if @roll.results.empty?
  end

  test 'should get index' do
    get randomizer_outcomes_path(@randomizer)

    assert_response :success
  end

  test 'should reroll and return turbo stream' do
    post reroll_randomizer_outcome_path(@randomizer, @roll), as: :turbo_stream

    assert_response :success
    assert_equal 'text/vnd.turbo-stream.html', response.media_type
    
    # Verify the response contains turbo-stream tags
    assert_match /turbo-stream/, response.body
  end

  test 'should handle reroll for roll with no results' do
    empty_roll = @randomizer.rolls.create!(name: 'Empty Roll', dice: 'D6')
    
    post reroll_randomizer_outcome_path(@randomizer, empty_roll), as: :turbo_stream

    assert_response :success
    # Should still return turbo stream even with no results
    assert_equal 'text/vnd.turbo-stream.html', response.media_type
  end
end
