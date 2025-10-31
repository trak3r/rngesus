class RollsController < ApplicationController
  before_action :set_randomizer
  before_action :set_roll, only: [:destroy]

  # POST /randomizers/:randomizer_id/rolls
  def create
    # Simple dice roll: default 1..6
    value = params[:sides].present? ? rand(1..params[:sides].to_i) : rand(1..6)
    @roll = @randomizer.rolls.build(value: value)

    if @roll.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append(dom_id(@randomizer, :rolls), partial: "rolls/roll", locals: { roll: @roll }),
            turbo_stream.update(:notice, "Rolled #{ @roll.value }")
          ]
        end
        format.html { redirect_to @randomizer, notice: "Rolled #{@roll.value}." }
      end
    else
      respond_to do |format|
        format.html { redirect_to @randomizer, alert: "Could not roll." }
      end
    end
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
