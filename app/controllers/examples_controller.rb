# frozen_string_literal: true

class ExamplesController < ApplicationController
  before_action :set_example, only: %i[show edit update destroy]

  # GET /examples
  def index
    @examples = Example.all
  end

  # GET /examples/1
  def show; end

  # GET /examples/new
  def new
    @example = Example.new
  end

  # GET /examples/1/edit
  def edit; end

  # POST /examples
  def create
    @example = Example.new(example_params)

    if @example.save
      redirect_to @example, notice: 'Example was successfully created.'
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /examples/1
  def update
    if @example.update(example_params)
      redirect_to @example, notice: 'Example was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /examples/1
  def destroy
    @example.destroy!
    redirect_to examples_path, notice: 'Example was successfully destroyed.', status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_example
    @example = Example.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def example_params
    params.expect(example: %i[name value])
  end
end
