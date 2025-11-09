class RollsController < ApplicationController
  before_action :set_roll, only: %i[ show edit update destroy ]
  before_action :set_randomizer, only: %i[ new create index ]

  # GET /rolls
  def index
    # @rolls = Roll.all
  end

  # GET /rolls/1
  def show
  end

  # GET /rolls/new
  def new
    @roll = @randomizer.rolls.build
  end

  # GET /rolls/1/edit
  def edit
  end

  # POST /rolls
  def create
    @roll = @randomizer.rolls.build(roll_params)

    if @roll.save
      redirect_to @roll, notice: "Roll was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /rolls/1
  def update
    if @roll.update(roll_params)
      redirect_to @roll, notice: "Roll was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /rolls/1
  def destroy
    @roll.destroy!
    redirect_to randomizer_rolls_path(@roll.randomizer),
      notice: "Roll was successfully destroyed.",
      status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_roll
      @roll = Roll.find(params.expect(:id))
    end

    def set_randomizer
      @randomizer = Randomizer.find(params.expect(:randomizer_id))
    end

    # Only allow a list of trusted parameters through.
    def roll_params
      params.expect(roll: [ :name, :dice ])
    end
end
