class RandomizersController < ApplicationController
  before_action :set_randomizer, only: %i[ show edit update destroy ]

  # GET /randomizers or /randomizers.json
  def index
    @randomizers = Randomizer.all
  end

  # GET /randomizers/1 or /randomizers/1.json
  def show
  end

  # GET /randomizers/new
  def new
    @randomizer = Randomizer.new
  end

  # GET /randomizers/1/edit
  def edit
  end

  # POST /randomizers or /randomizers.json
  def create
    @randomizer = Randomizer.new(randomizer_params)

    respond_to do |format|
      if @randomizer.save
        format.html { redirect_to @randomizer, notice: "Randomizer was successfully created." }
        format.json { render :show, status: :created, location: @randomizer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @randomizer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /randomizers/1 or /randomizers/1.json
  def update
    respond_to do |format|
      if @randomizer.update(randomizer_params)
        format.html { redirect_to @randomizer, notice: "Randomizer was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @randomizer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @randomizer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /randomizers/1 or /randomizers/1.json
  def destroy
    @randomizer.destroy!

    respond_to do |format|
      format.html { redirect_to randomizers_path, notice: "Randomizer was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
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
