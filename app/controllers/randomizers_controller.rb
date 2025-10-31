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

    respond_to do |format|
      if @randomizer.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append("randomizers", partial: "randomizer_card", locals: { randomizer: @randomizer }),
            turbo_stream.update(:new_randomizer, partial: "form", locals: { randomizer: Randomizer.new }),
            turbo_stream.update(:notice, "Randomizer was successfully created.")
          ]
        end
        format.html { redirect_to @randomizer, notice: "Randomizer was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /randomizers/1
  def update
    respond_to do |format|
      if @randomizer.update(randomizer_params)
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(@randomizer),
            turbo_stream.update(:notice, "Randomizer was successfully updated.")
          ]
        end
        format.html { redirect_to @randomizer, notice: "Randomizer was successfully updated.", status: :see_other }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /randomizers/1
  def destroy
    @randomizer.destroy!

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(@randomizer),
          turbo_stream.update(:notice, "Randomizer was successfully destroyed.")
        ]
      end
      format.html { redirect_to randomizers_path, notice: "Randomizer was successfully destroyed.", status: :see_other }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_randomizer
      @randomizer = Randomizer.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def randomizer_params
      params.require(:randomizer).permit(:name)
    end
end
