# frozen_string_literal: true

class ResultsImgsController < ApplicationController
  before_action :set_roll, only: %i[new create]

  def new
    @results_img = ResultsImg.new
  end

  def create
    files = Array(import_params[:file]).reject { |f| f.is_a?(String) && f.blank? }

    if files.empty?
      @results_img = ResultsImg.new
      @results_img.errors.add(:file, "can't be blank")
      render :new, status: :unprocessable_content
      return
    end

    processed_count = 0
    files.each do |file|
      ResultsImgProcessor.new(@roll, file).call
      processed_count += 1
    end

    # After upload, redirect to wizard form to complete randomizer details
    redirect_to new_randomizer_path(method: 'upload', upload_randomizer_id: @roll.randomizer.id),
                notice: t('.success', count: processed_count)
  end

  private

  def set_roll
    @roll = Roll.find(params.expect(:roll_id))
  end

  def import_params
    params.expect(results_img: [file: []])
  end
end
