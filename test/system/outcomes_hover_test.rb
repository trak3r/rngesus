# frozen_string_literal: true

require 'application_system_test_case'

class OutcomesHoverTest < ApplicationSystemTestCase
  setup do
    @user = users(:ted)
    @randomizer = randomizers(:encounter)

    # Create a new roll with a result that has dice notation
    @roll = @randomizer.rolls.create!(name: 'Test Roll', dice: 'D6')
    @result = @roll.results.create!(name: '1d6 goblins attack', value: 5)

    login_as @user
  end

  test 'outcome card has hover effects' do
    visit randomizer_outcomes_path(@randomizer)

    # Find the first outcome card (there may be multiple rolls)
    card = first('button.card-index')

    # Verify hover classes are present
    assert_includes card[:class], 'hover:shadow-lg'
    assert_includes card[:class], 'hover:scale-[1.02]'
    assert_includes card[:class], 'transition-all'
    assert_includes card[:class], 'duration-300'
  end

  test 'result text has toggle behavior classes' do
    visit randomizer_outcomes_path(@randomizer)

    # Find the result text container for our test roll
    within find('button.card-index', text: 'Test Roll') do
      result_container = find('.group.inline-block')

      # Verify container has group class for hover behavior
      assert_includes result_container[:class], 'group'

      # Find both spans - one visible by default, one shown on hover
      default_span = result_container.find('span.block', visible: :all)
      hover_span = result_container.find('span.hidden', visible: :all)

      # Verify default span has group-hover:hidden class
      assert_includes default_span[:class], 'group-hover:hidden'

      # Verify hover span has group-hover:block class
      assert_includes hover_span[:class], 'group-hover:block'
      assert_includes hover_span[:class], 'text-pencil/70'
    end
  end

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
