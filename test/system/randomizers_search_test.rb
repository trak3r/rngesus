# frozen_string_literal: true

require 'application_system_test_case'

class RandomizersSearchTest < ApplicationSystemTestCase
  setup do
    @user = User.create!(email: 'test@example.com', provider: 'developer', uid: '12345')
    @randomizer1 = @user.randomizers.create!(name: 'Dice Roller')
    @randomizer2 = @user.randomizers.create!(name: 'Card Deck')
    @randomizer3 = @user.randomizers.create!(name: 'Coin Flip')
  end

  test 'searching for randomizers filters the list' do
    visit randomizers_path

    # All randomizers should be visible initially
    assert_text 'Dice Roller'
    assert_text 'Card Deck'
    assert_text 'Coin Flip'

    # Search for "dice"
    fill_in 'query', with: 'dice'

    # Wait for Turbo to update the frame
    assert_text 'Dice Roller'
    assert_no_text 'Card Deck'
    assert_no_text 'Coin Flip'

    # Search for "card"
    fill_in 'query', with: 'card'

    assert_no_text 'Dice Roller'
    assert_text 'Card Deck'
    assert_no_text 'Coin Flip'

    # Clear search
    fill_in 'query', with: ''

    # All should be visible again
    assert_text 'Dice Roller'
    assert_text 'Card Deck'
    assert_text 'Coin Flip'
  end

  test 'shows no results message when no matches found' do
    visit randomizers_path

    fill_in 'query', with: 'nonexistent'

    assert_text 'No randomizers found matching "nonexistent"'
    assert_no_text 'Dice Roller'
    assert_no_text 'Card Deck'
    assert_no_text 'Coin Flip'
  end
end
