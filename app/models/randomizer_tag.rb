# frozen_string_literal: true

class RandomizerTag < ApplicationRecord
  belongs_to :randomizer
  belongs_to :tag
end
