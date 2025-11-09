class OutcomesController < ApplicationController
  before_action :set_randomizer, only: %i[ index ]

  def index
  end

  private

    def set_randomizer
      @randomizer = Randomizer.find(params.expect(:randomizer_id))
    end
end
