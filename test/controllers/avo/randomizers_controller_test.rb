# frozen_string_literal: true

require 'test_helper'

module Avo
  class RandomizersControllerTest < ActionDispatch::IntegrationTest
    setup do
      @admin_user = users(:ted)
      # Ensure user is admin (google_oauth2 with specific uid)
      @admin_user.update!(provider: 'google_oauth2', uid: '105389714176102520548')
      login_as(@admin_user)
    end

    test 'destroy action uses discard instead of destroy' do
      randomizer = randomizers(:encounter)

      assert_not randomizer.discarded?

      # Simulate Avo destroy action - Avo uses DELETE /resources/:resource_name/:id
      delete "/avo/resources/randomizers/#{randomizer.id}"

      randomizer.reload

      assert_predicate randomizer, :discarded?
      assert_not_nil randomizer.discarded_at
      # Verify record still exists in database
      assert Randomizer.with_discarded.exists?(randomizer.id)
    end

    test 'destroy action does not permanently delete record' do
      randomizer = randomizers(:encounter)
      original_id = randomizer.id
      original_count = Randomizer.with_discarded.count

      delete "/avo/resources/randomizers/#{randomizer.id}"

      # Record count should not change (soft delete, not hard delete)
      assert_equal original_count, Randomizer.with_discarded.count
      # Record should still exist in database
      assert Randomizer.with_discarded.exists?(original_id)
      # But should be discarded
      assert_predicate Randomizer.with_discarded.find(original_id), :discarded?
    end
  end
end
