# frozen_string_literal: true

require 'test_helper'

class ProfanityValidatorTest < ActiveSupport::TestCase
  # Create a simple test model to use the validator
  class TestModel
    include ActiveModel::Validations
    attr_accessor :content

    validates :content, profanity: true
  end

  test 'accepts clean text' do
    model = TestModel.new
    model.content = 'This is perfectly clean text'

    assert_predicate model, :valid?
  end

  test 'rejects profane text' do
    model = TestModel.new
    model.content = 'This contains shit'

    assert_not model.valid?
    assert_includes model.errors[:content], 'contains inappropriate language: shit'
  end

  test 'accepts blank text' do
    model = TestModel.new
    model.content = ''

    assert_predicate model, :valid?
  end

  test 'accepts nil text' do
    model = TestModel.new
    model.content = nil

    assert_predicate model, :valid?
  end

  test 'detects multiple profane words' do
    model = TestModel.new
    model.content = 'This has shit and fuck in it'

    assert_not model.valid?
    assert_match(/contains inappropriate language/, model.errors[:content].first)
  end
end
