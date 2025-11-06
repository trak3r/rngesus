class RollsController < ApplicationController
  before_action :set_randomizer, only: %i[ index new create ]
  before_action :set_roll, only: %i[ show edit update destroy ]

  # GET /rolls
  def index
    @rolls = @randomizer.rolls
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
      redirect_to randomizer_roll_path(@roll.randomizer, @roll), notice: "Roll was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /rolls/1
  def update
    @roll.update(roll_params)
    # FIXME: error status
    respond_to do |format|
      format.turbo_stream
    end
  end

  # DELETE /rolls/1
  def destroy
    @roll.destroy!
    respond_to do |format|
      format.turbo_stream
    end
  end

  private
    def set_randomizer
      @randomizer = Randomizer.find(params.expect(:randomizer_id))
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_roll
      @roll = Roll.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def roll_params
      # FIXME: can't update one param without all params
      params.expect(roll: [ :name, :dice ])
    end
end
