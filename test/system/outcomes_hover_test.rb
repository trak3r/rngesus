# frozen_string_literal: true

require 'application_system_test_case'

class OutcomesHoverTest < ApplicationSystemTestCase
  setup do
    @user = users(:ted)
    @randomizer = randomizers(:encounter)
    @roll = rolls(:roll_with_dice_notation)
    @result = results(:dice_notation_result)

    login_as @user
  end

  # HOVER EFFECT #1: Card hover - shadow and scale effects
  test 'outcome card has hover effects' do
    visit randomizer_outcomes_path(@randomizer)

    # Find the first outcome card (there may be multiple rolls)
    card = first('button.card-index')

    # Verify hover classes are present for card shadow/scale effect
    assert_includes card[:class], 'hover:shadow-lg'
    assert_includes card[:class], 'hover:scale-[1.02]'
    assert_includes card[:class], 'transition-all'
    assert_includes card[:class], 'duration-300'
  end

  # HOVER EFFECT #2a: Result text toggle - shows raw name vs expanded dice
  test 'result text has toggle behavior classes' do
    visit randomizer_outcomes_path(@randomizer)

    # Find the result text container for our test roll
    within find('button.card-index', text: 'Test Roll') do
      result_container = find('.group.inline-block')

      # Verify container has group class for hover behavior
      assert_includes result_container[:class], 'group'

      # Find both spans - one visible by default (expanded dice), one shown on hover (raw name)
      default_span = result_container.find('span.block', visible: :all)
      hover_span = result_container.find('span.hidden', visible: :all)

      # Verify default span has group-hover:hidden class (hides expanded dice on hover)
      assert_includes default_span[:class], 'group-hover:hidden'

      # Verify hover span has group-hover:block class (shows raw name on hover)
      assert_includes hover_span[:class], 'group-hover:block'
      assert_includes hover_span[:class], 'text-pencil/70'
    end
  end

  # HOVER EFFECT #2b: Tooltip - "Click to re-roll" message
  test 'outcome card has tooltip on hover' do
    visit randomizer_outcomes_path(@randomizer)

    # Find the first outcome card
    card = first('button.card-index')

    # Verify tooltip data attribute is present
    assert_equal 'Click to re-roll', card['data-tip']
    
    # Verify tooltip class is present
    assert_includes card[:class], 'tooltip'
  end

  # Styling verification
  test 'result text has correct styling classes' do
    visit randomizer_outcomes_path(@randomizer)

    result_container = first('.group.inline-block')

    # Verify container classes
    assert_includes result_container[:class], 'text-3xl'
    assert_includes result_container[:class], 'font-bold'
    assert_includes result_container[:class], 'font-typewriter'
    assert_includes result_container[:class], 'text-pencil'
  end
end
