# frozen_string_literal: true

class ResultsController < ApplicationController
  before_action :set_result, only: %i[edit update destroy]
  before_action :set_roll, only: %i[new create index]
  before_action :check_ownership, only: %i[edit update destroy]

  # GET /results
  def index
    # @results = Result.all
  end

  # GET /results/new
  def new
    @result = @roll.results.build
  end

  # GET /results/1/edit
  def edit; end

  # POST /results
  def create
    @result = @roll.results.build(result_params)

    if @result.save
      redirect_to @result.roll,
                  notice: t('.success')
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /results/1
  def update
    if @result.update(result_params)
      redirect_to @result.roll,
                  notice: t('results.create.success'),
                  status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /results/1
  def destroy
    @result.discard!
    # redirect_to results_path,
    # notice: "Result was successfully destroyed.",
    # status: :see_other
    redirect_to roll_path(@result.roll),
                notice: t('results.create.success'),
                status: :see_other
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
    params.expect(result: %i[name value])
  end

  def check_ownership
    return if @result.roll.user == current_user

    redirect_to rolls_path, alert: t('errors.unauthorized')
  end
end
