# frozen_string_literal: true

require 'test_helper'

class ResultsImgProcessorTest < ActiveSupport::TestCase
  setup do
    @roll = rolls(:encounter_forest)
  end

  test 'OCR and parse table with hyphenated results' do
    image_file = Rails.root.join('app/assets/images/forest_encounters_p154.png')
    assert_difference('@roll.results.count', 7) do
      processor = ResultsImgProcessor.new(@roll, image_file)
      # ap processor.to_s
      # ap processor.to_a
      # ap processor.parsed_list
      processor.call
    end
  end

  test 'OCR and parse table with colon-separated results' do
    image_file = Rails.root.join('test/ocr/d40 NPCs in the City of Masks.png')
    assert_difference('@roll.results.count', 10) do
      processor = ResultsImgProcessor.new(@roll, image_file)
      # ap processor.to_s
      # ap processor.to_a
      # ap processor.parsed_list

      # Verify that the parsing logic handles the OCR anomaly (Tl -> 11)
      result_eleven = processor.parsed_list.find { |row| row[0] == 11 }

      assert_not_nil result_eleven, 'Expected to parse result 11 despite OCR error'
      assert result_eleven[1].starts_with?('Mistress Savoy'), 'Expected correct text for result 11'

      processor.call
    end
  end

=begin
  test 'handles a more complicated image with 3 columns and multi-line rows' do
    image_file = Rails.root.join('test', 'ocr', 'carousing_outcome_p93.png')

    assert_difference('@roll.results.count', 14) do
      processor = ResultsImgProcessor.new(@roll, image_file)
      # ap processor.to_s
      ap processor.to_a
      ap processor.parsed_list
      processor.call
    end

    @roll.reload

    first_result = @roll.results.first
    last_result  = @roll.results.last

    assert first_result.name.ends_with?('bed'),
           "Expected first result to end with 'bed'"
    assert last_result.name.ends_with?('approach'),
           "Expected last result to end with 'approach'"
  end
=end
end
