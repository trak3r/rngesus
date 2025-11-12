# frozen_string_literal: true

class CreateRandomizers < ActiveRecord::Migration[8.1]
  def change
    create_table :randomizers, &:timestamps
  end
end
