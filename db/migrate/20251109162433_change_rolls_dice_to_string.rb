# frozen_string_literal: true

class ChangeRollsDiceToString < ActiveRecord::Migration[8.1]
  def change
    change_table :rolls, bulk: true do |t|
      t.remove :dice
      t.string :dice
    end
  end
end
