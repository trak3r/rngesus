class RandomizersController < ApplicationController
  before_action :set_randomizer, only: %i[ show edit update destroy ]

  # GET /randomizers
  def index
    @randomizers = Randomizer.all
  end

  # GET /randomizers/1
  def show
  end

  # GET /randomizers/new
  def new
    @randomizer = Randomizer.new
  end

  # GET /randomizers/1/edit
  def edit
  end

  # POST /randomizers
  def create
    @randomizer = Randomizer.new(randomizer_params)

    if @randomizer.save
      redirect_to @randomizer, notice: "Randomizer was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /randomizers/1
  def update
    if @randomizer.update(randomizer_params)
      redirect_to @randomizer, notice: "Randomizer was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /randomizers/1
  def destroy
    @randomizer.destroy!
    redirect_to randomizers_path, notice: "Randomizer was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_randomizer
      @randomizer = Randomizer.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def randomizer_params
      params.fetch(:randomizer, {})
    end
end
