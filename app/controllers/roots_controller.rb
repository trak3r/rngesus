# frozen_string_literal: true

class RootsController < ApplicationController
  def index
    if current_user
      redirect_to rolls_path(tab: 'your_rolls')
    else
      redirect_to rolls_path(tab: 'most_liked')
    end
  end
end
