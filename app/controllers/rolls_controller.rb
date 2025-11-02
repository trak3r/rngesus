class RollsController < ApplicationController
  before_action :set_randomizer
  before_action :set_roll, only: [ :destroy, :show ]

  # GET /randomizers/:randomizer_id/rolls/new
  def new
    @roll = @randomizer.rolls.build
  end

  # POST /randomizers/:randomizer_id/rolls
  def create
    # Accept roll params (name) and sides (optional); default sides to 6
    # Accept roll params (name). We no longer store a numeric value on Roll.
    roll_params = params.fetch(:roll, {}).permit(:name)
    @roll = @randomizer.rolls.build(roll_params)

    if @roll.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append(dom_id(@randomizer, :rolls), partial: "rolls/roll", locals: { roll: @roll }),
            turbo_stream.update(:notice, "Created roll: #{ @roll.name }")
          ]
        end
        format.html { redirect_to [@randomizer, @roll], notice: "Created roll #{@roll.name}." }
      end
    else
      respond_to do |format|
        format.html { redirect_to @randomizer, alert: "Could not create roll: #{ @roll.errors.full_messages.join(', ') }" }
      end
    end
  end

  # GET /randomizers/:randomizer_id/rolls/:id
  def show
  end

  # DELETE /randomizers/:randomizer_id/rolls/:id
  def destroy
    @roll.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(@roll),
          turbo_stream.update(:notice, "Roll removed")
        ]
      end
      format.html { redirect_to @randomizer, notice: "Roll destroyed." }
    end
  end

  private
    def set_randomizer
      @randomizer = Randomizer.find(params[:randomizer_id])
    end

    def set_roll
      @roll = @randomizer.rolls.find(params[:id])
    end
end
