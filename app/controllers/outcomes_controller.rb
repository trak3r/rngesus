# frozen_string_literal: true

class OutcomesController < ApplicationController
  before_action :set_randomizer, only: %i[index reroll]
  before_action :set_roll, only: %i[reroll]

  def index; end

  def reroll
    @roll = @randomizer.rolls.find(params[:id])
    @rolled, @result = @roll.outcome
    
    # Calculate index for staggered animation timing
    @index = @randomizer.rolls.order(:id).index(@roll) || 0

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def set_randomizer
    @randomizer = Randomizer.find_by!(slug: params.expect(:randomizer_id))
  end

  def set_roll
    @roll = @randomizer.rolls.find(params.expect(:id))
  end
end
