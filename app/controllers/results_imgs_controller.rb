# frozen_string_literal: true

class ResultsImgsController < ApplicationController
  before_action :set_roll, only: %i[new create]

  def new
    @results_img = ResultsImg.new
  end

  def create
    @results_img = ResultsImg.new(import_params)
    if @results_img.valid?
      ResultsImgProcessor.new(@roll, @results_img.file).call
      redirect_to @roll,
                  notice: t('.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_roll
    @roll = Roll.find(params.expect(:roll_id))
  end

  def import_params
    params.expect(results_img: [:file])
  end
end
