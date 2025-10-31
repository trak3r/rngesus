class RollsController < ApplicationController
  before_action :set_randomizer
  before_action :set_roll, only: [:destroy]

  # POST /randomizers/:randomizer_id/rolls
  def create
    # Accept roll params (name) and sides (optional); default sides to 6
    sides = if params.dig(:roll, :sides).present?
              params.dig(:roll, :sides).to_i
            elsif params[:sides].present?
              params[:sides].to_i
            else
              6
            end

    value = rand(1..[sides, 1].max)

    roll_params = params.fetch(:roll, {}).permit(:name)
    @roll = @randomizer.rolls.build(roll_params.merge(value: value))

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
        format.html { redirect_to @randomizer, alert: "Could not roll: #{ @roll.errors.full_messages.join(', ') }" }
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
