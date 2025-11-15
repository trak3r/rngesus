# frozen_string_literal: true

require 'test_helper'

class ResultsImgProcessorTest < ActiveSupport::TestCase
  setup do
    @roll = rolls(:encounter_forest)
  end

  test 'creates results from OCR image' do
    image_file = Rails.root.join('app/assets/images/forest_encounters_p154.png')
    assert_difference('@roll.results.count', 23) do
      ResultsImgProcessor.new(@roll, image_file).call
    end
  end

  test 'handles a more complicated image with 3 columns and multi-line rows' do
    image_file = Rails.root.join('test/ocr/carousing_outcome_p93.png')

    assert_difference('@roll.results.count', 14) do
      ResultsImgProcessor.new(@roll, image_file).call
    end

    @roll.reload

    first_result = @roll.results.first
    last_result  = @roll.results.last

    assert first_result.name.ends_with?('bed'),
           "Expected first result to end with 'bed'"
    assert last_result.name.ends_with?('approach'),
           "Expected last result to end with 'approach'"
  end
end
