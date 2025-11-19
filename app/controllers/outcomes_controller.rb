# frozen_string_literal: true

class OutcomesController < ApplicationController
  before_action :set_randomizer, only: %i[index reroll]
  before_action :set_roll, only: %i[reroll]

  def index; end

  def reroll
    @rolled, @result = @roll.outcome

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def set_randomizer
    @randomizer = Randomizer.find(params.expect(:randomizer_id))
  end

  def set_roll
    @roll = @randomizer.rolls.find(params.expect(:id))
  end
end
