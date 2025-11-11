class ResultsCsvsController < ApplicationController
  before_action :set_roll, only: %i[ new ]

  def new
    @import = ResultsCsv.new
  end

  def create
    @import = ResultsCsv.new(import_params)
    if @import.valid?
      CsvProcessor.new(@parent, @import.file).call
      redirect_to @parent, notice: "CSV processed successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

    def set_roll
      @roll = Roll.find(params.expect(:roll_id))
    end

  def import_params
    params.require(:import_form).permit(:file)
  end
end

