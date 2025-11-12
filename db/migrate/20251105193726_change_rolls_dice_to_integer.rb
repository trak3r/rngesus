# frozen_string_literal: true

class ChangeRollsDiceToInteger < ActiveRecord::Migration[8.1]
  def change
    remove_column :rolls, :dice
    add_column :rolls, :dice, :integer
  end
end
