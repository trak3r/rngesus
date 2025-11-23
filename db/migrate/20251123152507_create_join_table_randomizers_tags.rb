# frozen_string_literal: true

class CreateJoinTableRandomizersTags < ActiveRecord::Migration[8.1]
  def change
    create_join_table :randomizers, :tags do |t|
      t.index %i[randomizer_id tag_id], unique: true
    end
  end
end
