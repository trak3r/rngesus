# frozen_string_literal: true

class RemoveRandomizers < ActiveRecord::Migration[8.1]
  def change
    remove_reference :rolls, :randomizer, null: false, foreign_key: true
    drop_table :randomizer_tags
    drop_table :randomizers
  end
end
