# frozen_string_literal: true

require 'test_helper'

class ResultsImgProcessorTest < ActiveSupport::TestCase
  setup do
    @roll = rolls(:encounter_forest)
    @image_file = Rails.root.join('test/ocr/forest_encounters_p154.png')
  end
  test 'creates results from OCR image' do
    assert_difference('@roll.results.count', 23) do
      ResultsImgProcessor.new(@roll, @image_file).call
    end
  end
end
