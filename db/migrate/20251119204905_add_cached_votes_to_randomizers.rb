class AddCachedVotesToRandomizers < ActiveRecord::Migration[8.1]
  def change
    add_column :randomizers, :cached_votes_total, :integer, default: 0
    add_column :randomizers, :cached_votes_score, :integer, default: 0
    add_column :randomizers, :cached_votes_up, :integer, default: 0
    add_column :randomizers, :cached_votes_down, :integer, default: 0
    
    # Update cached votes for existing randomizers
    reversible do |dir|
      dir.up do
        Randomizer.find_each(&:update_cached_votes)
      end
    end
  end
end
