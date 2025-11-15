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

  test 'handle a more complicated image with 3 columns and multi-line rows' do
    image_file = Rails.root.join('test/ocr/carousing_outcome_p93.png')
    assert_difference('@roll.results.count', 14) do
      ResultsImgProcessor.new(@roll, image_file).call
    end
  end
end
