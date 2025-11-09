class ResultsController < ApplicationController
  before_action :set_result, only: %i[ show edit update destroy ]
  before_action :set_roll, only: %i[ new create ]

  # GET /results
  def index
    @results = Result.all
  end

  # GET /results/1
  def show
  end

  # GET /results/new
  def new
    @result = @roll.results.build
  end

  # GET /results/1/edit
  def edit
  end

  # POST /results
  def create
    @result = @roll.results.build(result_params)

    if @result.save
      redirect_to @result, notice: "Result was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /results/1
  def update
    if @result.update(result_params)
      redirect_to @result, notice: "Result was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /results/1
  def destroy
    @result.destroy!
    # redirect_to results_path, notice: "Result was successfully destroyed.", status: :see_other
    redirect_to roll_path(@result.roll), notice: "Result was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_result
      @result = Result.find(params.expect(:id))
    end

    def set_roll
      @roll = Roll.find(params.expect(:roll_id))
    end

    # Only allow a list of trusted parameters through.
    def result_params
      params.expect(result: [ :name, :value ])
    end
end
