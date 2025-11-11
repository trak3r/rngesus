class ResultsCsvsController < ApplicationController
  before_action :set_roll, only: %i[ new create ]

  def new
    @results_csv = ResultsCsv.new
  end

  def create
    @results_csv = ResultsCsv.new(import_params)
    if @results_csv.valid?
      ResultsCsvProcessor.new(@roll, @results_csv.file).call
      redirect_to @roll, notice: "CSV processed successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

    def set_roll
      @roll = Roll.find(params.expect(:roll_id))
    end

  def import_params
    params.require(:results_csv).permit(:file)
  end
end

