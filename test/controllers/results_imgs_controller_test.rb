# frozen_string_literal: true

require 'test_helper'

class ResultsImgsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @roll = rolls(:encounter_forest)
    @file_path = Rails.root.join('app/assets/images/forest_encounters_p154.png')
  end

  test 'should ignore empty string in file array and process valid files' do
    # This test verifies that the bug is fixed and empty strings are ignored
    assert_difference('@roll.results.count', 7) do
      post roll_results_imgs_path(@roll), params: {
        results_img: {
          file: ['', fixture_file_upload(@file_path, 'image/png')]
        }
      }
    end

    assert_redirected_to new_randomizer_path(method: 'upload', upload_randomizer_id: @roll.randomizer.id)
    assert_equal 'Screenshot was successfully processed.', flash[:notice]
  end

  test 'should redirect to roll page when source is roll' do
    post roll_results_imgs_path(@roll), params: {
      source: 'roll',
      results_img: {
        file: [fixture_file_upload(@file_path, 'image/png')]
      }
    }

    assert_redirected_to @roll
    assert_equal 'Screenshot was successfully processed.', flash[:notice]
  end
end
