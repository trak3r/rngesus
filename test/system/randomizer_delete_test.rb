# frozen_string_literal: true

require 'application_system_test_case'

class RandomizerDeleteTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @randomizer = randomizers(:encounter)
    
    # Stub authentication
    RandomizersController.any_instance.stubs(:current_user).returns(@user)
    OutcomesController.any_instance.stubs(:current_user).returns(@user)
  end

  test 'delete button only appears on Your Randomizers tab' do
    visit randomizers_path

    # Should NOT see delete button on default tab (newest)
    within first('.card-index') do
      assert_no_selector '[title="Delete"]', visible: :all
    end

    # Navigate to Your Randomizers tab
    click_link 'Your Randomizers'
    
    # Should see delete button on user's own randomizers
    within first('.card-index') do
      assert_selector '[title="Delete"]'
    end
  end

  test 'delete confirmation dialog appears and can be cancelled' do
    visit randomizers_path(tab: 'your_randomizers')
    
    initial_count = Randomizer.count
    
    # Click delete button
    within first('.card-index') do
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
    within first('.card-index') do
      page.accept_confirm do
        click_button title: 'Delete'
      end
    end
    
    # Should redirect to randomizers index
    assert_current_path randomizers_path
    
    # Randomizer should be deleted
    assert_equal initial_count - 1, Randomizer.count
    
    # Should show success message
    assert_text 'Randomizer was successfully destroyed'
    
    # Card should no longer appear
    assert_no_text randomizer_name
  end

  test 'delete button has correct styling and hover effects' do
    visit randomizers_path(tab: 'your_randomizers')
    
    within first('.card-index') do
      delete_button = find('[title="Delete"]')
      
      # Check initial styling
      assert delete_button[:class].include?('text-pencil/30')
      assert delete_button[:class].include?('hover:text-red-600')
      
      # Check icon is present
      assert_selector 'svg', count: 1, within: delete_button
    end
  end

  test 'delete button is centered in card footer grid' do
    visit randomizers_path(tab: 'your_randomizers')
    
    within first('.card-index .card-actions') do
      # Verify grid layout
      assert_selector '.grid.grid-cols-3'
      
      # Delete button should be in center column with justify-self-center
      delete_container = find('.justify-self-center')
      assert_selector '[title="Delete"]', within: delete_container
    end
  end
end
