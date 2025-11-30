# frozen_string_literal: true

class ChangeRollsDiceToInteger < ActiveRecord::Migration[8.1]
  def change
    change_table :rolls, bulk: true do |t|
      t.remove :dice
      t.integer :dice
    end
  end
end
