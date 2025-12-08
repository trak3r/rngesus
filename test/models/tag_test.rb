# frozen_string_literal: true

require 'test_helper'

class TagTest < ActiveSupport::TestCase
  test 'should require name' do
    tag = Tag.new

    assert_not tag.valid?
    assert_includes tag.errors[:name], "can't be blank"
  end

  test 'should require unique name' do
    Tag.create!(name: 'Fantasy')
    duplicate_tag = Tag.new(name: 'Fantasy')

    assert_not duplicate_tag.valid?
    assert_includes duplicate_tag.errors[:name], 'has already been taken'
  end

  test 'should create tag with valid name' do
    tag = Tag.new(name: 'Sci-Fi')

    assert_predicate tag, :valid?
    assert tag.save
  end

  test 'should have many rolls through roll_tags' do
    tag = Tag.create!(name: 'Adventure')
    roll = rolls(:encounter_distance)

    roll.tags << tag

    assert_includes tag.rolls, roll
    assert_equal 1, tag.rolls.count
  end

  test 'should destroy roll_tags when tag is destroyed' do
    tag = Tag.create!(name: 'Horror')
    roll = rolls(:encounter_distance)
    roll.tags << tag

    assert_difference('RollTag.count', -1) do
      tag.destroy
    end
  end

  test 'can discard a tag' do
    tag = tags(:forest)

    assert_not tag.discarded?
    tag.discard

    assert_predicate tag, :discarded?
    assert_not_nil tag.discarded_at
  end

  test 'can restore a discarded tag' do
    tag = tags(:forest)
    tag.discard

    assert_predicate tag, :discarded?
    tag.undiscard

    assert_not tag.discarded?
    assert_nil tag.discarded_at
  end

  test 'discarded tag is excluded from default scope' do
    tag = tags(:forest)
    tag.discard

    assert_not_includes Tag.kept, tag
    assert_includes Tag.with_discarded, tag
  end
end
