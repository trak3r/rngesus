# frozen_string_literal: true

require 'test_helper'

class RandomizersSearchTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: 'test@example.com', provider: 'developer', uid: '12345')
    @randomizer1 = @user.randomizers.create!(name: 'Dice Roller')
    @randomizer2 = @user.randomizers.create!(name: 'Card Deck')
    @randomizer3 = @user.randomizers.create!(name: 'Coin Flip')
  end

  test 'searching for randomizers filters the list' do
    # All randomizers should be visible initially (using newest tab since most_liked filters out 0-like items)
    get randomizers_path(tab: 'newest')

    assert_response :success
    assert_select 'body', text: /Dice Roller/
    assert_select 'body', text: /Card Deck/
    assert_select 'body', text: /Coin Flip/

    # Search for "dice"
    get randomizers_path(tab: 'newest', query: 'dice')

    assert_response :success
    assert_select 'body', text: /Dice Roller/
    assert_select 'body', text: /Card Deck/, count: 0
    assert_select 'body', text: /Coin Flip/, count: 0

    # Search for "card"
    get randomizers_path(tab: 'newest', query: 'card')

    assert_response :success
    assert_select 'body', text: /Dice Roller/, count: 0
    assert_select 'body', text: /Card Deck/
    assert_select 'body', text: /Coin Flip/, count: 0

    # Empty search returns all
    get randomizers_path(tab: 'newest', query: '')

    assert_response :success
    assert_select 'body', text: /Dice Roller/
    assert_select 'body', text: /Card Deck/
    assert_select 'body', text: /Coin Flip/
  end

  test 'shows no results message when no matches found' do
    get randomizers_path(tab: 'newest', query: 'nonexistent')

    assert_response :success
    assert_select 'body', text: /No randomizers found\.\.\./
    assert_select 'body', text: /matching "nonexistent"/
    assert_select 'body', text: /Dice Roller/, count: 0
    assert_select 'body', text: /Card Deck/, count: 0
    assert_select 'body', text: /Coin Flip/, count: 0
  end
end
