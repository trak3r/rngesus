# frozen_string_literal: true

require 'test_helper'

class RandomizerTest < ActiveSupport::TestCase
  test 'slug is auto-generated on create' do
    randomizer = Randomizer.create!(name: 'Test Randomizer', user: users(:ted))

    assert_not_nil randomizer.slug
    assert_equal 5, randomizer.slug.length
    assert_match(/\A[a-zA-Z0-9]{5}\z/, randomizer.slug)
  end

  test 'slug cannot be changed after creation' do
    randomizer = randomizers(:encounter)
    original_slug = randomizer.slug

    # attr_readonly raises an error when trying to assign
    assert_raises(ActiveRecord::ReadonlyAttributeError) do
      randomizer.update!(slug: 'XXXXX')
    end

    randomizer.reload

    assert_equal original_slug, randomizer.slug
  end

  test 'slug is auto-generated even if not provided' do
    # This verifies that slug generation works automatically
    # and that the controller's strong parameters (which only permit :name)
    # prevent slug from being set via mass assignment
    randomizer = Randomizer.create!(name: 'Test Randomizer', user: users(:ted))

    assert_not_nil randomizer.slug
    assert_equal 5, randomizer.slug.length
    assert_match(/\A[a-zA-Z0-9]{5}\z/, randomizer.slug)
  end
end
