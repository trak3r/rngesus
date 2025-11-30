# frozen_string_literal: true

class AddCachedVotesToRandomizers < ActiveRecord::Migration[8.1]
  def change
    change_table :randomizers, bulk: true do |t|
      t.integer :cached_votes_total, default: 0
      t.integer :cached_votes_score, default: 0
      t.integer :cached_votes_up, default: 0
      t.integer :cached_votes_down, default: 0
    end

    # Update cached votes for existing randomizers
    reversible do |dir|
      dir.up do
        Randomizer.find_each(&:update_cached_votes)
      end
    end
  end
end
