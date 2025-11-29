# frozen_string_literal: true

require 'test_helper'

class OutcomesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @randomizer = randomizers(:encounter)
    @roll = rolls(:encounter_distance)
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
    assert_match(/turbo-stream/, response.body)
  end

  test 'should handle reroll for roll with no results' do
    empty_roll = rolls(:empty_roll)

    post reroll_randomizer_outcome_path(@randomizer, empty_roll), as: :turbo_stream

    assert_response :success
    # Should still return turbo stream even with no results
    assert_equal 'text/vnd.turbo-stream.html', response.media_type
  end

  test 'index should not include discarded rolls' do
    # Create an additional roll and discard it
    discarded_roll = @randomizer.rolls.create!(name: 'Discarded Roll', dice: 'D6')
    discarded_roll.discard!

    get randomizer_outcomes_path(@randomizer)

    assert_response :success
    # The discarded roll should not appear in the response
    assert_no_match(/Discarded Roll/, response.body)
    # Only active rolls should be shown
    active_rolls_count = @randomizer.rolls.count
    assert active_rolls_count > 0, 'Should have active rolls'
  end

  test 'reroll should not work for discarded roll' do
    roll_id = @roll.id
    
    # Discard a roll
    @roll.discard!
    
    # Verify the roll is discarded
    assert_predicate @roll.reload, :discarded?
    
    # Verify the roll cannot be found using kept scope
    assert_raises(ActiveRecord::RecordNotFound) do
      Roll.kept.find(roll_id)
    end

    # Attempting to reroll a discarded roll should return 404
    # The set_roll before_action should raise RecordNotFound which Rails converts to 404
    post "/randomizers/#{@randomizer.slug}/outcomes/#{roll_id}/reroll", as: :turbo_stream
    
    assert_response :not_found
  end

  test 'index should only show active rolls' do
    # Get initial count of active rolls
    initial_active_count = @randomizer.rolls.count

    # Create and discard a roll
    new_roll = @randomizer.rolls.create!(name: 'Test Roll', dice: 'D6')
    new_roll.discard!

    # Active count should remain the same
    assert_equal initial_active_count, @randomizer.rolls.count
    # Discarded roll should not be in the association
    assert_not_includes @randomizer.rolls, new_roll
  end
end
