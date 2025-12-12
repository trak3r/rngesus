# frozen_string_literal: true

class ResultsCsvsController < ApplicationController
  before_action :set_roll, only: %i[new create]

  def new
    @results_csv = ResultsCsv.new
  end

  def create
    files = Array(import_params[:file]).reject { |f| f.is_a?(String) && f.blank? }

    if files.empty?
      @results_csv = ResultsCsv.new
      @results_csv.errors.add(:file, "can't be blank")
      render :new, status: :unprocessable_content
      return
    end

    processed_count = 0
    files.each do |file|
      ResultsCsvProcessor.new(@roll, file).call
      processed_count += 1
    end

    # Redirect based on source
    if params[:source] == 'roll'
      redirect_to @roll, notice: t('.success', count: processed_count)
    else
      # Wizard flow
      redirect_to new_roll_path(method: 'upload', upload_roll_id: @roll.id),
                  notice: t('.success', count: processed_count)
    end
  end

  private

  def set_roll
    @roll = Roll.find_by!(slug: params.expect(:roll_id))
  end

  def import_params
    params.expect(results_csv: [file: []])
  end
end
