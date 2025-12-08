# frozen_string_literal: true

class RollTag < ApplicationRecord
  belongs_to :roll
  belongs_to :tag
end
