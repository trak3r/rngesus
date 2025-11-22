# frozen_string_literal: true

require 'test_helper'

class ImmutableAttributesTest < ActiveSupport::TestCase
  # Create a test model to verify the concern works
  class TestModel < ApplicationRecord
    self.table_name = 'randomizers'
    include ImmutableAttributes

    attr_immutable :slug
  end

  test 'attr_immutable makes attribute readonly' do
    model = TestModel.first
    original_slug = model.slug

    # Should raise error when trying to update immutable attribute
    assert_raises(ActiveRecord::ReadonlyAttributeError) do
      model.update!(slug: 'XXXXX')
    end

    model.reload

    assert_equal original_slug, model.slug
  end

  test 'attr_immutable prevents assignment with error' do
    model = TestModel.first

    # attr_readonly raises an error when trying to assign via update
    assert_raises(ActiveRecord::ReadonlyAttributeError) do # rubocop:disable Minitest/AssertRaisesCompoundBody
      model.slug = 'XXXXX'
      model.save!
    end
  end

  test 'attr_immutable works with multiple attributes' do
    # This test verifies the concern can handle multiple attributes
    # We'll just verify the method exists and can be called
    assert_respond_to TestModel, :attr_immutable

    # Verify it can be called with multiple arguments
    assert_nothing_raised do
      Class.new(ApplicationRecord) do
        self.table_name = 'randomizers'
        include ImmutableAttributes

        attr_immutable :slug, :name
      end
    end
  end
end
