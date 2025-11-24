# frozen_string_literal: true

require 'application_system_test_case'

class RandomizersIndexTest < ApplicationSystemTestCase
  setup do
    @user = users(:ted)
    @randomizer = randomizers(:encounter)
  end

  test 'randomizer name is truncated' do
    # Create a randomizer with a long name
    long_name = 'This is a very long randomizer name that should definitely be truncated because it is way too long to fit on a single line or even two lines'
    Randomizer.create!(name: long_name, user: @user)

    visit randomizers_path

    # Check for the presence of the line-clamp class
    assert_selector 'h2.line-clamp-1', text: long_name
  end

  test 'rolls are limited to 2 and show more indicator' do
    # Create a randomizer with many rolls
    randomizer = Randomizer.create!(name: 'Many Rolls', user: @user)
    5.times { |i| randomizer.rolls.create!(name: "Roll #{i}", dice: '1d6') }

    visit randomizers_path

    within "#randomizer_#{randomizer.id}" do
      assert_text 'Roll 0'
      assert_text 'Roll 1'
      assert_no_text 'Roll 2'
      assert_text '...and more'
    end
  end

  test 'cards have consistent layout structure' do
    visit randomizers_path
    # Verify the grid structure is present (checking for the class we plan to add)
    assert_selector '.grid'
  end
end
