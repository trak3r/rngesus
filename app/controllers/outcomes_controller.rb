# frozen_string_literal: true

class OutcomesController < ApplicationController
  before_action :set_randomizer, only: %i[index reroll]
  before_action :set_roll, only: %i[reroll]

  def index; end

  def reroll
    # @roll is set by set_roll before_action, which ensures it's not discarded
    @rolled, @result = @roll.outcome

    # Calculate index for staggered animation timing
    # @randomizer.rolls already excludes discarded rolls due to association scope
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
    # Find roll using kept scope to exclude discarded rolls
    # Also verify it belongs to this randomizer
    roll_id = params.expect(:id)
    @roll = Roll.kept.find(roll_id)

    # Ensure the roll belongs to this randomizer
    return unless @roll.randomizer_id != @randomizer.id

    raise ActiveRecord::RecordNotFound
  end
end
