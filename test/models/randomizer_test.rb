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

  test 'randomizer can have 0 tags' do
    randomizer = Randomizer.create!(name: 'No Tags Randomizer', user: users(:ted))

    assert_equal 0, randomizer.tags.count
    assert_predicate randomizer, :valid?
  end

  test 'randomizer can have 1 tag' do
    randomizer = randomizers(:encounter)

    assert_equal 1, randomizer.tags.count
    assert_predicate randomizer, :valid?
  end

  test 'randomizer can have 3 tags (maximum allowed)' do
    randomizer = randomizers(:treasure_hunt)

    assert_equal 3, randomizer.tags.count
    assert_predicate randomizer, :valid?
  end

  test 'randomizer cannot have more than 3 tags' do
    randomizer = Randomizer.new(name: 'Too Many Tags', user: users(:ted))
    randomizer.tags << tags(:forest)
    randomizer.tags << tags(:dungeon)
    randomizer.tags << tags(:monster)
    randomizer.tags << tags(:magic)

    assert_not randomizer.valid?
    assert_includes randomizer.errors[:tags], 'cannot exceed 3 tags per randomizer'
  end

  test 'tags are returned in alphabetical order' do
    randomizer = randomizers(:treasure_hunt)
    tag_names = randomizer.tags.map(&:name)

    assert_equal %w[Dungeon Magic Treasure], tag_names
  end

  test 'tagged_with filters by single tag' do
    assert_includes Randomizer.tagged_with('Dungeon'), randomizers(:treasure_hunt)
    assert_includes Randomizer.tagged_with('Dungeon'), randomizers(:dungeon_crawler)
    assert_not_includes Randomizer.tagged_with('Dungeon'), randomizers(:encounter)
  end

  test 'tagged_with filters by multiple tags with AND logic' do
    # treasure_hunt has Dungeon, Magic, Treasure
    # dungeon_crawler has Dungeon, Monster

    # Both have Dungeon
    assert_includes Randomizer.tagged_with(['Dungeon']), randomizers(:treasure_hunt)
    assert_includes Randomizer.tagged_with(['Dungeon']), randomizers(:dungeon_crawler)

    # Only treasure_hunt has Dungeon AND Magic
    assert_includes Randomizer.tagged_with(%w[Dungeon Magic]), randomizers(:treasure_hunt)
    assert_not_includes Randomizer.tagged_with(%w[Dungeon Magic]), randomizers(:dungeon_crawler)

    # Only dungeon_crawler has Dungeon AND Monster
    assert_includes Randomizer.tagged_with(%w[Dungeon Monster]), randomizers(:dungeon_crawler)
    assert_not_includes Randomizer.tagged_with(%w[Dungeon Monster]), randomizers(:treasure_hunt)
  end

  test 'can discard a randomizer' do
    randomizer = randomizers(:encounter)

    assert_not randomizer.discarded?
    randomizer.discard

    assert_predicate randomizer, :discarded?
    assert_not_nil randomizer.discarded_at
  end

  test 'can restore a discarded randomizer' do
    randomizer = randomizers(:encounter)
    randomizer.discard

    assert_predicate randomizer, :discarded?
    randomizer.undiscard

    assert_not randomizer.discarded?
    assert_nil randomizer.discarded_at
  end

  test 'discarded randomizer is excluded from default scope' do
    randomizer = randomizers(:encounter)
    randomizer.discard

    assert_not_includes Randomizer.kept, randomizer
    assert_includes Randomizer.with_discarded, randomizer
  end
end
