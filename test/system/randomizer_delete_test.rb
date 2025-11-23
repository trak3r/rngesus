# frozen_string_literal: true

require 'application_system_test_case'

class RandomizerDeleteTest < ApplicationSystemTestCase
  setup do
    @user = users(:ted)
    @randomizer = randomizers(:encounter)
    login_as @user
  end

  test 'user is logged in' do
    visit randomizers_path
    assert_selector "img[alt='#{@user.display_name}\\'s avatar']"
  end

  test 'delete button only appears on Your Randomizers tab' do
    visit randomizers_path

    # Should NOT see delete button on default tab (newest)
    # We need to find the specific card for our randomizer
    # The "New Randomizer" card is always first, so we can't use first('.card-index')
    
    # Find card with randomizer name
    card = find('.card-index', text: @randomizer.name)
    
    within card do
      assert_no_selector 'button[title="Delete"]', visible: :all
    end

    # Navigate to Your Randomizers tab
    click_link 'Your Randomizers'

    # Should see delete button on user's own randomizers
    card = find('.card-index', text: @randomizer.name)
    within card do
      assert_selector 'button[title="Delete"]'
    end
  end

  test 'delete confirmation dialog appears and can be cancelled' do
    visit randomizers_path(tab: 'your_randomizers')

    initial_count = Randomizer.count

    # Click delete button
    card = find('.card-index', text: @randomizer.name)
    within card do
      # Accept the confirmation dialog (this is handled by Capybara automatically)
      # To test cancellation, we'd need to use accept_confirm/dismiss_confirm
      page.dismiss_confirm do
        click_button title: 'Delete'
      end
    end

    # Randomizer should NOT be deleted
    assert_equal initial_count, Randomizer.count
  end

  test 'delete confirmation dialog can be accepted to delete randomizer' do
    visit randomizers_path(tab: 'your_randomizers')

    initial_count = Randomizer.count
    randomizer_name = @randomizer.name

    # Click delete button and accept confirmation
    card = find('.card-index', text: @randomizer.name)
    within card do
      page.accept_confirm do
        click_button title: 'Delete'
      end
    end

    # Should redirect to randomizers index
    assert_current_path randomizers_path, ignore_query: true

    # Randomizer should be deleted
    assert_equal initial_count - 1, Randomizer.count

    # Card should no longer appear
    assert_no_text randomizer_name
    
    # Note: Flash message is not checked because the delete happens within a Turbo Frame,
    # and flash messages are rendered outside the frame in the layout
  end

  test 'delete button has correct styling and hover effects' do
    visit randomizers_path(tab: 'your_randomizers')

    card = find('.card-index', text: @randomizer.name)
    within card do
      delete_button = find('button[title="Delete"]')

      # Check initial styling
      assert_includes delete_button[:class], 'text-pencil/30'
      assert_includes delete_button[:class], 'hover:text-red-600'

      # Check icon is present
      within delete_button do
        assert_selector 'svg', count: 1
      end
    end
  end

  test 'delete button is centered in card footer grid' do
    visit randomizers_path(tab: 'your_randomizers')

    card = find('.card-index', text: @randomizer.name)
    card_actions = card.find('.card-actions')
    
    # Verify grid layout
    assert_includes card_actions[:class], 'grid'
    assert_includes card_actions[:class], 'grid-cols-3'

    within card_actions do
      # Delete button should be in center column with justify-self-center
      delete_container = find('.justify-self-center')

      within delete_container do
        assert_selector 'button[title="Delete"]'
      end
    end
  end
end
