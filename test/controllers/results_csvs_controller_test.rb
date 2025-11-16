# frozen_string_literal: true

require 'test_helper'

class ResultsCsvsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @roll = rolls(:encounter_forest)
    @file_path = Rails.root.join('test/csv/forest_encounters_p154.csv')
  end

  test 'creates results from uploaded CSV' do
    file = fixture_file_upload(@file_path, 'text/csv')

    assert_difference('@roll.results.count', 23) do
      post roll_results_csvs_path(@roll), params: {
        results_csv: { file: file }
      }
    end

    assert_redirected_to roll_path(@roll)
    follow_redirect!

    assert_match 'CSV was successfully processed.', response.body
  end
end
